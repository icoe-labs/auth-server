--
-- Turn off autocommit and start a transaction so that we can use the temp tables
--

SET AUTOCOMMIT FALSE;

START TRANSACTION;

--
-- Insert user information into the temporary tables. To add users to the HSQL database, edit things here.
-- 

INSERT INTO users_TEMP (username, password, enabled) VALUES
  ('admin','password',true),
  ('user','password',true),
  ('aaron','password',true),
  ('demo1','password',true),
  ('daan','password',true),
  ('gordon','password',true),
  ('mike','password',true),
  ('mohammed','password',true),
  ('ben','password',true),
  ('eric','password',true),
  ('ellen','password',true),
  ('bill','password',true),
  ('jeanne','password',true),
  ('diedre','password',true),
  ('brian','password',true),
  ('mohan','password',true),
  ('scott','password',true),
  ('sergio','password',true),
  ('nagesh','password',true),
  ('uri','password',true),
  ('brent','password',true),
  ('david','password',true),
  ('matt','password',true);


INSERT INTO authorities_TEMP (username, authority) VALUES
  ('admin','ROLE_ADMIN'),
  ('admin','ROLE_USER'),
  ('user','ROLE_USER'),
  ('aaron','ROLE_USER'),
  ('demo1','ROLE_USER'),
  ('daan','ROLE_USER'),
  ('gordon','ROLE_USER'),
  ('mike','ROLE_USER'),
  ('mohammed','ROLE_USER'),
  ('ben','ROLE_USER'),
  ('eric','ROLE_USER'),
  ('ellen','ROLE_USER'),
  ('bill','ROLE_USER'),
  ('jeanne','ROLE_USER'),
  ('diedre','ROLE_USER'),
  ('brian','ROLE_USER'),
  ('mohan','ROLE_USER'),
  ('scott','ROLE_USER'),
  ('sergio','ROLE_USER'),
  ('nagesh','ROLE_USER'),
  ('uri','ROLE_USER'),
  ('brent','ROLE_USER'),
  ('david','ROLE_USER'),
  ('matt','ROLE_USER');
    
-- By default, the username column here has to match the username column in the users table, above
INSERT INTO user_info_TEMP (sub, preferred_username, name, email, email_verified, profile) VALUES
  ('90342.ASDFJWFA','admin','Demo Admin','admin@example.com', true,''),
  ('01921.FLANRJQW','user','Demo User','user@example.com', true,''),
  ('01922.ASKLNCSK','aaron','Aaron Alexis','user@example.com', true,'http://icoe-smart-fhir-jelastic-server.cloudhub.io/Patient/9995679'),
  ('01921.FLANRJQW','demo1','demo1 User','demo1@example.com', true,''),
  ('01921.FLANRJQW','daan','Daan','daan@example.com', true,''),
  ('01921.FLANRJQW','gordon','Gordon','gordon@example.com', true,''),
  ('01921.FLANRJQW','mike','Mike','mike@example.com', true,''),
  ('01921.FLANRJQW','mohammed','Mohammed','mohammed@example.com', true,''),
  ('01921.FLANRJQW','ben','Ben','ben@example.com', true,''),
  ('01921.FLANRJQW','eric','Eric','eric@example.com', true,''),
  ('01921.FLANRJQW','ellen','Ellen','ellen@example.com', true,''),
  ('01921.FLANRJQW','bill','Bill','bill@example.com', true,''),
  ('01921.FLANRJQW','jeanne','Jeanne','jeanne@example.com', true,''),
  ('01921.FLANRJQW','diedre','Diedre','diedre@example.com', true,''),
  ('01921.FLANRJQW','brian','Brian','brian@example.com', true,''),
  ('01921.FLANRJQW','mohan','Mohan','mohan@example.com', true,''),
  ('01921.FLANRJQW','scott','Scott','scott@example.com', true,''),
  ('01921.FLANRJQW','sergio','Sergio','sergio@example.com', true,''),
  ('01921.FLANRJQW','nagesh','Nagesh','nagesh@example.com', true,''),
  ('01921.FLANRJQW','uri','Uri','uri@example.com', true,''),
  ('01921.FLANRJQW','brent','Brent','brent@example.com', true,''),
  ('01921.FLANRJQW','david','David','david@example.com', true,''),
  ('01921.FLANRJQW','matt','Matt','matt@example.com', true,'');

 
--
-- Merge the temporary users safely into the database. This is a two-step process to keep users from being created on every startup with a persistent store.
--

MERGE INTO users 
  USING (SELECT username, password, enabled FROM users_TEMP) AS vals(username, password, enabled)
  ON vals.username = users.username
  WHEN NOT MATCHED THEN 
    INSERT (username, password, enabled) VALUES(vals.username, vals.password, vals.enabled);

MERGE INTO authorities 
  USING (SELECT username, authority FROM authorities_TEMP) AS vals(username, authority)
  ON vals.username = authorities.username AND vals.authority = authorities.authority
  WHEN NOT MATCHED THEN 
    INSERT (username,authority) values (vals.username, vals.authority);

MERGE INTO user_info 
  USING (SELECT sub, preferred_username, name, email, email_verified, profile FROM user_info_TEMP) AS vals(sub, preferred_username, name, email, email_verified, profile)
  ON vals.preferred_username = user_info.preferred_username
  WHEN NOT MATCHED THEN 
    INSERT (sub, preferred_username, name, email, email_verified, profile) VALUES (vals.sub, vals.preferred_username, vals.name, vals.email, vals.email_verified, vals.profile);

    
-- 
-- Close the transaction and turn autocommit back on
-- 
    
COMMIT;

SET AUTOCOMMIT TRUE;

