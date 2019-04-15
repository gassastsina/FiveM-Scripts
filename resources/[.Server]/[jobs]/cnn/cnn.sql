INSERT INTO `addon_account` (name, label, shared) VALUES
  ('society_cnn','Journaliste',1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
  ('society_cnn','Journaliste',1)
;

INSERT INTO `jobs` (name, label) VALUES 
	('reporter','Journaliste')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male) VALUES
	('reporter',0,'recruit','Stagiaire', 20,'{\"tshirt_1\":15,\"torso_1\":39,\"arms\":0,\"pants_1\":1,\"glasses\":7,\"decals_2\":0,\"hair_color_2\":0,\"helmet_2\":0,\"hair_color_1\":5,\"face\":19,\"glasses_2\":0,\"torso_2\":0,\"shoes\":8,\"hair_1\":2,\"skin\":34,\"sex\":0,\"glasses_1\":7,\"pants_2\":0,\"hair_2\":0,\"decals_1\":0,\"tshirt_2\":0,\"helmet_1\":-1}'),
	('reporter',1,'reporter','Journaliste', 50,'{\"tshirt_1\":10,\"torso_1\":76,\"shoes\":20,\"pants_1\":22,\"pants_2\":0,\"decals_2\":1,\"hair_color_2\":0,\"face\":19,\"helmet_2\":1,\"hair_2\":0,\"arms\":12,\"decals_1\":0,\"torso_2\":0,\"hair_1\":2,\"skin\":34,\"sex\":0,\"glasses_1\":17,\"glasses_2\":0,\"hair_color_1\":5,\"glasses\":17,\"tshirt_2\":1,\"helmet_1\":7}'),
	('reporter',2,'drh','Rédacteur en chef', 70,'{\"tshirt_1\":31,\"torso_1\":99,\"shoes\":40,\"pants_1\":48,\"pants_2\":0,\"decals_2\":0,\"hair_color_2\":0,\"face\":19,\"helmet_2\":2,\"hair_2\":0,\"glasses\":17,\"decals_1\":0,\"hair_color_1\":5,\"hair_1\":2,\"skin\":34,\"sex\":0,\"glasses_1\":17,\"glasses_2\":4,\"torso_2\":4,\"arms\":12,\"tshirt_2\":1,\"helmet_1\":25}'),
	('reporter',3,'boss','Président', 85,'{\"tshirt_1\":31,\"torso_1\":99,\"shoes\":40,\"pants_1\":48,\"pants_2\":0,\"decals_2\":0,\"hair_color_2\":0,\"face\":19,\"helmet_2\":2,\"hair_2\":0,\"glasses\":17,\"decals_1\":0,\"hair_color_1\":5,\"hair_1\":2,\"skin\":34,\"sex\":0,\"glasses_1\":17,\"glasses_2\":4,\"torso_2\":4,\"arms\":12,\"tshirt_2\":1,\"helmet_1\":25}')
;