-- ==========================================================================
--  BALUNI HOSTEL — create / repair BOTH app logins
--  Run in Supabase Dashboard → SQL Editor → New query → paste all → Run
--
--    Warden    : staff@hostel.app       password: staff@123
--    Principal : principal@hostel.app   password: principalbaluni@321
--
--  Safe to re-run any time — it resets the passwords to the values above and
--  repairs broken user rows (fixes the "Database error querying schema" /
--  endless "wrong password" problem caused by earlier setup scripts).
-- ==========================================================================

CREATE EXTENSION IF NOT EXISTS "pgcrypto";

DO $$
DECLARE
    rec RECORD;
    v_user_id UUID;
    v_pw TEXT;
BEGIN
    FOR rec IN
        SELECT * FROM (VALUES
            ('staff@hostel.app',     'staff@123'),
            ('principal@hostel.app', 'principalbaluni@321')
        ) AS t(email, pw)
    LOOP
        v_pw := crypt(rec.pw, gen_salt('bf'));
        SELECT id INTO v_user_id FROM auth.users WHERE email = rec.email;

        IF v_user_id IS NULL THEN
            -- create the user fresh (with ALL token fields as '' — required by Supabase auth)
            v_user_id := gen_random_uuid();
            INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password,
                                    email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
                                    confirmation_token, recovery_token, email_change,
                                    email_change_token_new, email_change_token_current,
                                    phone_change, phone_change_token, reauthentication_token,
                                    created_at, updated_at)
            VALUES (v_user_id, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
                    rec.email, v_pw, NOW(),
                    '{"provider":"email","providers":["email"]}', '{}',
                    '', '', '', '', '', '', '', '',
                    NOW(), NOW());
            RAISE NOTICE 'User created: %', rec.email;
        ELSE
            -- user exists: reset password AND repair any NULL token fields that
            -- make Supabase auth throw "Database error querying schema" on login
            UPDATE auth.users SET
                encrypted_password         = v_pw,
                email_confirmed_at         = COALESCE(email_confirmed_at, NOW()),
                aud                        = 'authenticated',
                role                       = 'authenticated',
                raw_app_meta_data          = COALESCE(raw_app_meta_data, '{"provider":"email","providers":["email"]}'::jsonb),
                raw_user_meta_data         = COALESCE(raw_user_meta_data, '{}'::jsonb),
                confirmation_token         = COALESCE(confirmation_token, ''),
                recovery_token             = COALESCE(recovery_token, ''),
                email_change               = COALESCE(email_change, ''),
                email_change_token_new     = COALESCE(email_change_token_new, ''),
                email_change_token_current = COALESCE(email_change_token_current, ''),
                phone_change               = COALESCE(phone_change, ''),
                phone_change_token         = COALESCE(phone_change_token, ''),
                reauthentication_token     = COALESCE(reauthentication_token, ''),
                banned_until               = NULL,
                deleted_at                 = NULL,
                updated_at                 = NOW()
            WHERE id = v_user_id;
            RAISE NOTICE 'Password reset + row repaired for: %', rec.email;
        END IF;

        -- ensure the email identity mapping exists (login fails without it)
        INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id,
                                     last_sign_in_at, created_at, updated_at)
        VALUES (v_user_id, v_user_id,
                format('{"sub":"%s","email":"%s","email_verified":true}', v_user_id::text, rec.email)::jsonb,
                'email', v_user_id::text, NOW(), NOW(), NOW())
        ON CONFLICT (provider, provider_id) DO UPDATE
            SET identity_data = EXCLUDED.identity_data, updated_at = NOW();
    END LOOP;
END $$;
