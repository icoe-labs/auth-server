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
  ('Aaron','password',true),
  ('Demo1','password',true),
  ('Daan','password',true),
  ('Gordon','password',true),
  ('Mike','password',true),
  ('Mohammed','password',true),
  ('Ben','password',true),
  ('Eric','password',true),
  ('Ellen','password',true),
  ('Bill','password',true),
  ('Jeanne','password',true),
  ('Diedre','password',true),
  ('Brian','password',true),
  ('Mohan','password',true),
  ('Scott','password',true),
  ('Sergio','password',true),
  ('Nagesh','password',true),
  ('Uri','password',true),
  ('Brent','password',true),
  ('David','password',true),
  ('Matt','password',true),
  ('Kristin','password',true);


INSERT INTO authorities_TEMP (username, authority) VALUES
  ('admin','ROLE_ADMIN'),
  ('admin','ROLE_USER'),
  ('user','ROLE_USER'),
  ('Aaron','ROLE_USER'),
  ('Demo1','ROLE_USER'),
  ('Daan','ROLE_USER'),
  ('Gordon','ROLE_USER'),
  ('Mike','ROLE_USER'),
  ('Mohammed','ROLE_USER'),
  ('Ben','ROLE_USER'),
  ('Eric','ROLE_USER'),
  ('Ellen','ROLE_USER'),
  ('Bill','ROLE_USER'),
  ('Jeanne','ROLE_USER'),
  ('Diedre','ROLE_USER'),
  ('Brian','ROLE_USER'),
  ('Mohan','ROLE_USER'),
  ('Scott','ROLE_USER'),
  ('Sergio','ROLE_USER'),
  ('Nagesh','ROLE_USER'),
  ('Uri','ROLE_USER'),
  ('Brent','ROLE_USER'),
  ('David','ROLE_USER'),
  ('Matt','ROLE_USER'),
  ('Kristin','ROLE_USER');
    
-- By default, the username column here has to match the username column in the users table, above
INSERT INTO user_info_TEMP (sub, preferred_username, name, email, email_verified, profile) VALUES
  ('90342.ASDFJWFA','admin','Demo Admin','admin@example.com', true,''),
  ('01921.FLANRJQW','user','Demo User','user@example.com', true,''),
  ('01922.ASKLNCSK','Aaron','Aaron Alexis','user@example.com', true,'http://icoe-smart-fhir-jelastic-server.cloudhub.io/Patient/9995679'),
  ('01921.FLANRJQW','Demo1','demo1 User','demo1@example.com', true,''),
  ('01921.FLANRJQW','Daan','Daan','daan@example.com', true,''),
  ('01921.FLANRJQW','Gordon','Gordon','gordon@example.com', true,''),
  ('01921.FLANRJQW','Mike','Mike','mike@example.com', true,''),
  ('01921.FLANRJQW','Mohammed','Mohammed','mohammed@example.com', true,''),
  ('01921.FLANRJQW','Ben','Ben','ben@example.com', true,''),
  ('01921.FLANRJQW','Eric','Eric','eric@example.com', true,''),
  ('01921.FLANRJQW','Ellen','Ellen','ellen@example.com', true,''),
  ('01921.FLANRJQW','Bill','Bill','bill@example.com', true,''),
  ('01921.FLANRJQW','Jeanne','Jeanne','jeanne@example.com', true,''),
  ('01921.FLANRJQW','Diedre','Diedre','diedre@example.com', true,''),
  ('01921.FLANRJQW','Brian','Brian','brian@example.com', true,''),
  ('01921.FLANRJQW','Mohan','Mohan','mohan@example.com', true,''),
  ('01921.FLANRJQW','Scott','Scott','scott@example.com', true,''),
  ('01921.FLANRJQW','Sergio','Sergio','sergio@example.com', true,''),
  ('01921.FLANRJQW','Nagesh','Nagesh','nagesh@example.com', true,''),
  ('01921.FLANRJQW','Uri','Uri','uri@example.com', true,''),
  ('01921.FLANRJQW','Brent','Brent','brent@example.com', true,''),
  ('01921.FLANRJQW','David','David','david@example.com', true,''),
  ('01921.FLANRJQW','Matt','Matt','matt@example.com', true,''),
  ('01921.FLANRJQW','Kristin','Kristin','kristin@example.com', true,'');

 
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

