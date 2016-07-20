--
-- Turn off autocommit and start a transaction so that we can use the temp tables
--

SET AUTOCOMMIT FALSE;

START TRANSACTION;

--
-- Insert client information into the temporary tables. To add clients to the HSQL database, edit things here.
--

INSERT INTO client_details_TEMP (client_id, client_secret, client_name, dynamically_registered, refresh_token_validity_seconds, access_token_validity_seconds, id_token_validity_seconds, allow_introspection)
VALUES
  ('client', 'secret', 'Test Client', FALSE, NULL, 3600, 600, TRUE);

INSERT INTO client_details_TEMP (client_id, client_name, dynamically_registered, refresh_token_validity_seconds, access_token_validity_seconds, id_token_validity_seconds, allow_introspection)
VALUES
  ('growth_chart', 'Growth Chart', FALSE, NULL, 3600, 600, FALSE);

INSERT INTO client_details_TEMP (client_id, client_name, dynamically_registered, refresh_token_validity_seconds, access_token_validity_seconds, id_token_validity_seconds, allow_introspection)
VALUES
  ('bp_centiles', 'BP Centiles', FALSE, NULL, 3600, 600, FALSE);

INSERT INTO client_details_TEMP (client_id, client_name, dynamically_registered, refresh_token_validity_seconds, access_token_validity_seconds, id_token_validity_seconds, allow_introspection)
VALUES
  ('cardiac_risk', 'Cardiac Risk App', FALSE, NULL, 3600, 600, FALSE);

INSERT INTO client_details_TEMP (client_id, client_name, dynamically_registered, refresh_token_validity_seconds, access_token_validity_seconds, id_token_validity_seconds, allow_introspection)
VALUES
  ('fhir_starter', 'FHIR Starter', FALSE, NULL, 3600, 600, FALSE);

--TODO: Curl script for these...
INSERT INTO client_scope_TEMP (owner_id, scope) VALUES
  ('client', 'openid'),
  ('client', 'profile'),
  ('client', 'email'),
  ('client', 'address'),
  ('client', 'phone'),
  ('client', 'search'),
  ('client', 'summary'),
  ('client', 'smart'),
  ('client', 'smart/orchestrate_launch'),
  ('client', 'launch'),
  ('client', 'launch/patient'),
  ('client', 'launch/encounter'),
  ('client', 'launch/other'),
  ('client', 'smart'),
  ('client', 'user/Patient.read'),
  ('client', 'user/*.*'),
  ('client', 'user/*.read'),
  ('client', 'patient/*.*'),
  ('client', 'patient/*.read'),
  ('client', 'offline_access');

INSERT INTO client_scope_TEMP (owner_id, scope) VALUES
  ('fhir_starter', 'openid'),
  ('fhir_starter', 'profile'),
  ('fhir_starter', 'email'),
  ('fhir_starter', 'address'),
  ('fhir_starter', 'phone'),
  ('fhir_starter', 'launch'),
  ('fhir_starter', 'smart/orchestrate_launch'),
  ('fhir_starter', 'user/*.*');
;

INSERT INTO client_scope_TEMP (owner_id, scope) VALUES
  ('growth_chart', 'openid'),
  ('growth_chart', 'profile'),
  ('growth_chart', 'email'),
  ('growth_chart', 'address'),
  ('growth_chart', 'phone'),
  ('growth_chart', 'launch'),
  ('growth_chart', 'launch/patient'),
  ('growth_chart', 'patient/*.read');

INSERT INTO client_scope_TEMP (owner_id, scope) VALUES
  ('bp_centiles', 'openid'),
  ('bp_centiles', 'profile'),
  ('bp_centiles', 'email'),
  ('bp_centiles', 'address'),
  ('bp_centiles', 'phone'),
  ('bp_centiles', 'launch'),
  ('bp_centiles', 'launch/patient'),
  ('bp_centiles', 'patient/*.read');

INSERT INTO client_scope_TEMP (owner_id, scope) VALUES
  ('cardiac_risk', 'openid'),
  ('cardiac_risk', 'profile'),
  ('cardiac_risk', 'email'),
  ('cardiac_risk', 'address'),
  ('cardiac_risk', 'phone'),
  ('cardiac_risk', 'launch'),
  ('cardiac_risk', 'launch/patient'),
  ('cardiac_risk', 'patient/*.read');


INSERT INTO client_redirect_uri_TEMP (owner_id, redirect_uri) VALUES
  ('client', 'http://localhost/'),
  ('client', 'http://localhost:8080/');

INSERT INTO client_redirect_uri_TEMP (owner_id, redirect_uri) VALUES
  ('growth_chart', 'http://icoe-smart-apps.cloudhub.io/apps/growth-chart'),
  ('growth_chart', 'http://icoe-smart-apps.cloudhub.io/apps/growth-chart/'),
  ('growth_chart', 'http://localhost:8000/apps/growth-chart'),
  ('growth_chart', 'http://localhost:8000/apps/growth-chart/');

INSERT INTO client_redirect_uri_TEMP (owner_id, redirect_uri) VALUES
  ('bp_centiles', 'http://icoe-smart-apps.cloudhub.io/apps/bp-centiles'),
  ('bp_centiles', 'http://icoe-smart-apps.cloudhub.io/apps/bp-centiles/'),
  ('bp_centiles', 'http://localhost:8000/apps/bp-centiles'),
  ('bp_centiles', 'http://localhost:8000/apps/bp-centiles/');

INSERT INTO client_redirect_uri_TEMP (owner_id, redirect_uri) VALUES
  ('cardiac_risk', 'http://icoe-smart-apps.cloudhub.io/apps/cardiac-risk'),
  ('cardiac_risk', 'http://icoe-smart-apps.cloudhub.io/apps/cardiac-risk/'),
  ('cardiac_risk', 'http://localhost:8000/apps/cardiac-risk'),
  ('cardiac_risk', 'http://localhost:8000/apps/cardiac-risk/');


INSERT INTO client_redirect_uri_TEMP (owner_id, redirect_uri) VALUES
  ('fhir_starter', 'http://icoe-smart-apps.cloudhub.io'),
  ('fhir_starter', 'http://icoe-smart-apps.cloudhub.io/'),
  ('fhir_starter', 'http://localhost:8000'),
  ('fhir_starter', 'http://localhost:8000/');


INSERT INTO client_grant_type_TEMP (owner_id, grant_type) VALUES
  ('client', 'authorization_code'),
  ('client', 'urn:ietf:params:oauth:grant_type:redelegate'),
  ('client', 'implicit'),
  ('client', 'refresh_token');

INSERT INTO client_grant_type_TEMP (owner_id, grant_type) VALUES
  ('growth_chart', 'authorization_code');

INSERT INTO client_grant_type_TEMP (owner_id, grant_type) VALUES
  ('bp_centiles', 'authorization_code');

INSERT INTO client_grant_type_TEMP (owner_id, grant_type) VALUES
  ('cardiac_risk', 'authorization_code');

INSERT INTO client_grant_type_TEMP (owner_id, grant_type) VALUES
  ('fhir_starter', 'authorization_code');

-- Merge the temporary clients safely into the database. This is a two-step process to keep clients from being created on every startup with a persistent store.
--
--

MERGE INTO client_details
USING (SELECT
         client_id,
         client_secret,
         client_name,
         dynamically_registered,
         refresh_token_validity_seconds,
         access_token_validity_seconds,
         id_token_validity_seconds,
         allow_introspection
       FROM
         client_details_TEMP) AS vals(client_id, client_secret, client_name, dynamically_registered, refresh_token_validity_seconds, access_token_validity_seconds, id_token_validity_seconds, allow_introspection)
ON vals.client_id = client_details.client_id
WHEN NOT MATCHED THEN
INSERT (client_id, client_secret, client_name, dynamically_registered, refresh_token_validity_seconds, access_token_validity_seconds, id_token_validity_seconds, allow_introspection)
  VALUES (client_id, client_secret, client_name, dynamically_registered, refresh_token_validity_seconds,
          access_token_validity_seconds, id_token_validity_seconds, allow_introspection);

MERGE INTO client_scope
USING (SELECT
         id,
         scope
       FROM client_scope_TEMP, client_details
       WHERE client_details.client_id = client_scope_TEMP.owner_id) AS vals(id, scope)
ON vals.id = client_scope.owner_id AND vals.scope = client_scope.scope
WHEN NOT MATCHED THEN
INSERT (owner_id, scope) VALUES (vals.id, vals.scope);

MERGE INTO client_redirect_uri
USING (SELECT
         id,
         redirect_uri
       FROM client_redirect_uri_TEMP, client_details
       WHERE client_details.client_id = client_redirect_uri_TEMP.owner_id) AS vals(id, redirect_uri)
ON vals.id = client_redirect_uri.owner_id AND vals.redirect_uri = client_redirect_uri.redirect_uri
WHEN NOT MATCHED THEN
INSERT (owner_id, redirect_uri) VALUES (vals.id, vals.redirect_uri);

MERGE INTO client_grant_type
USING (SELECT
         id,
         grant_type
       FROM client_grant_type_TEMP, client_details
       WHERE client_details.client_id = client_grant_type_TEMP.owner_id) AS vals(id, grant_type)
ON vals.id = client_grant_type.owner_id AND vals.grant_type = client_grant_type.grant_type
WHEN NOT MATCHED THEN
INSERT (owner_id, grant_type) VALUES (vals.id, vals.grant_type);

--
-- Close the transaction and turn autocommit back on
--

COMMIT;

SET AUTOCOMMIT TRUE;
