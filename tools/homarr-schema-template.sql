-- Homarr Seed Database Template
-- Generated from Homarr v1.x schema
-- This file contains the schema and essential bootstrap data

PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;

CREATE TABLE IF NOT EXISTS "__drizzle_migrations" (
				id SERIAL PRIMARY KEY,
				hash text NOT NULL,
				created_at numeric
			);
CREATE TABLE `app` (
	`id` text PRIMARY KEY NOT NULL,
	`name` text NOT NULL,
	`description` text,
	`icon_url` text NOT NULL,
	`href` text
, `ping_url` text);
CREATE TABLE `boardGroupPermission` (
	`board_id` text NOT NULL,
	`group_id` text NOT NULL,
	`permission` text NOT NULL,
	PRIMARY KEY(`board_id`, `group_id`, `permission`),
	FOREIGN KEY (`board_id`) REFERENCES `board`(`id`) ON UPDATE no action ON DELETE cascade,
	FOREIGN KEY (`group_id`) REFERENCES `group`(`id`) ON UPDATE no action ON DELETE cascade
);
CREATE TABLE `boardUserPermission` (
	`board_id` text NOT NULL,
	`user_id` text NOT NULL,
	`permission` text NOT NULL,
	PRIMARY KEY(`board_id`, `permission`, `user_id`),
	FOREIGN KEY (`board_id`) REFERENCES `board`(`id`) ON UPDATE no action ON DELETE cascade,
	FOREIGN KEY (`user_id`) REFERENCES "user"(`id`) ON UPDATE no action ON DELETE cascade
);
CREATE TABLE `board` (
	`id` text PRIMARY KEY NOT NULL,
	`name` text NOT NULL,
	`is_public` integer DEFAULT false NOT NULL,
	`creator_id` text,
	`page_title` text,
	`meta_title` text,
	`logo_image_url` text,
	`favicon_image_url` text,
	`background_image_url` text,
	`background_image_attachment` text DEFAULT 'fixed' NOT NULL,
	`background_image_repeat` text DEFAULT 'no-repeat' NOT NULL,
	`background_image_size` text DEFAULT 'cover' NOT NULL,
	`primary_color` text DEFAULT '#fa5252' NOT NULL,
	`secondary_color` text DEFAULT '#fd7e14' NOT NULL,
	`opacity` integer DEFAULT 100 NOT NULL,
	`custom_css` text,
	`disable_status` integer DEFAULT false NOT NULL, `item_radius` text DEFAULT 'lg' NOT NULL, `icon_color` text,
	FOREIGN KEY (`creator_id`) REFERENCES "user"(`id`) ON UPDATE no action ON DELETE set null
);
CREATE TABLE `iconRepository` (
	"id" text PRIMARY KEY NOT NULL,
	"slug" text NOT NULL
);
CREATE TABLE `integration_item` (
	`item_id` text NOT NULL,
	`integration_id` text NOT NULL,
	PRIMARY KEY(`integration_id`, `item_id`),
	FOREIGN KEY (`item_id`) REFERENCES `item`(`id`) ON UPDATE no action ON DELETE cascade,
	FOREIGN KEY (`integration_id`) REFERENCES `integration`(`id`) ON UPDATE no action ON DELETE cascade
);
CREATE TABLE `integrationSecret` (
	`kind` text NOT NULL,
	`value` text NOT NULL,
	`updated_at` integer NOT NULL,
	`integration_id` text NOT NULL,
	PRIMARY KEY(`integration_id`, `kind`),
	FOREIGN KEY (`integration_id`) REFERENCES `integration`(`id`) ON UPDATE no action ON DELETE cascade
);
CREATE TABLE `integration` (
	`id` text PRIMARY KEY NOT NULL,
	`name` text NOT NULL,
	`url` text NOT NULL,
	`kind` text NOT NULL
, `app_id` text REFERENCES app(id));
CREATE TABLE `invite` (
	`id` text PRIMARY KEY NOT NULL,
	`token` text NOT NULL,
	`expiration_date` integer NOT NULL,
	`creator_id` text NOT NULL,
	FOREIGN KEY (`creator_id`) REFERENCES "user"(`id`) ON UPDATE no action ON DELETE cascade
);
CREATE TABLE `verificationToken` (
	`identifier` text NOT NULL,
	`token` text NOT NULL,
	`expires` integer NOT NULL,
	PRIMARY KEY(`identifier`, `token`)
);
CREATE UNIQUE INDEX `board_name_unique` ON `board` (`name`);
CREATE INDEX `integration_secret__kind_idx` ON `integrationSecret` (`kind`);
CREATE INDEX `integration_secret__updated_at_idx` ON `integrationSecret` (`updated_at`);
CREATE INDEX `integration__kind_idx` ON `integration` (`kind`);
CREATE UNIQUE INDEX `invite_token_unique` ON `invite` (`token`);
CREATE TABLE `serverSetting` (
	"setting_key" text PRIMARY KEY NOT NULL,
	`value` text DEFAULT '{"json": {}}' NOT NULL
);
CREATE TABLE `integrationGroupPermissions` (
	`integration_id` text NOT NULL,
	`group_id` text NOT NULL,
	`permission` text NOT NULL,
	PRIMARY KEY(`group_id`, `integration_id`, `permission`),
	FOREIGN KEY (`integration_id`) REFERENCES `integration`(`id`) ON UPDATE no action ON DELETE cascade,
	FOREIGN KEY (`group_id`) REFERENCES `group`(`id`) ON UPDATE no action ON DELETE cascade
);
CREATE TABLE `integrationUserPermission` (
	`integration_id` text NOT NULL,
	`user_id` text NOT NULL,
	`permission` text NOT NULL,
	PRIMARY KEY(`integration_id`, `permission`, `user_id`),
	FOREIGN KEY (`integration_id`) REFERENCES `integration`(`id`) ON UPDATE no action ON DELETE cascade,
	FOREIGN KEY (`user_id`) REFERENCES `user`(`id`) ON UPDATE no action ON DELETE cascade
);
CREATE TABLE `media` (
	`id` text PRIMARY KEY NOT NULL,
	`name` text NOT NULL,
	`content` blob NOT NULL,
	`content_type` text NOT NULL,
	`size` integer NOT NULL,
	`created_at` integer DEFAULT (unixepoch()) NOT NULL,
	`creator_id` text,
	FOREIGN KEY (`creator_id`) REFERENCES `user`(`id`) ON UPDATE no action ON DELETE set null
);
CREATE TABLE IF NOT EXISTS "search_engine" (
	`id` text PRIMARY KEY NOT NULL,
	`icon_url` text NOT NULL,
	`name` text NOT NULL,
	`short` text NOT NULL,
	`description` text,
	`url_template` text,
	`type` text DEFAULT 'generic' NOT NULL,
	`integration_id` text,
	FOREIGN KEY (`integration_id`) REFERENCES `integration`(`id`) ON UPDATE no action ON DELETE cascade
);
CREATE TABLE IF NOT EXISTS "account" (
	`user_id` text NOT NULL,
	`type` text NOT NULL,
	`provider` text NOT NULL,
	`provider_account_id` text NOT NULL,
	`refresh_token` text,
	`access_token` text,
	`expires_at` integer,
	`token_type` text,
	`scope` text,
	`id_token` text,
	`session_state` text,
	PRIMARY KEY(`provider`, `provider_account_id`),
	FOREIGN KEY (`user_id`) REFERENCES `user`(`id`) ON UPDATE no action ON DELETE cascade
);
CREATE INDEX `userId_idx` ON `account` (`user_id`);
CREATE TABLE IF NOT EXISTS "apiKey" (
	`id` text PRIMARY KEY NOT NULL,
	`api_key` text NOT NULL,
	`salt` text NOT NULL,
	`user_id` text NOT NULL,
	FOREIGN KEY (`user_id`) REFERENCES `user`(`id`) ON UPDATE no action ON DELETE cascade
);
CREATE TABLE IF NOT EXISTS "groupMember" (
	`group_id` text NOT NULL,
	`user_id` text NOT NULL,
	PRIMARY KEY(`group_id`, `user_id`),
	FOREIGN KEY (`group_id`) REFERENCES `group`(`id`) ON UPDATE no action ON DELETE cascade,
	FOREIGN KEY (`user_id`) REFERENCES `user`(`id`) ON UPDATE no action ON DELETE cascade
);
CREATE TABLE IF NOT EXISTS "groupPermission" (
	`group_id` text NOT NULL,
	`permission` text NOT NULL,
	FOREIGN KEY (`group_id`) REFERENCES `group`(`id`) ON UPDATE no action ON DELETE cascade
);
CREATE TABLE IF NOT EXISTS "icon" (
	`id` text PRIMARY KEY NOT NULL,
	`name` text NOT NULL,
	`url` text NOT NULL,
	`checksum` text NOT NULL,
	`icon_repository_id` text NOT NULL,
	FOREIGN KEY (`icon_repository_id`) REFERENCES `iconRepository`(`id`) ON UPDATE no action ON DELETE cascade
);
CREATE UNIQUE INDEX `serverSetting_settingKey_unique` ON `serverSetting` (`setting_key`);
CREATE TABLE IF NOT EXISTS "session" (
	`session_token` text PRIMARY KEY NOT NULL,
	`user_id` text NOT NULL,
	`expires` integer NOT NULL,
	FOREIGN KEY (`user_id`) REFERENCES `user`(`id`) ON UPDATE no action ON DELETE cascade
);
CREATE INDEX `user_id_idx` ON `session` (`user_id`);
CREATE TABLE `onboarding` (
	`id` text PRIMARY KEY NOT NULL,
	`step` text NOT NULL,
	`previous_step` text
);
CREATE UNIQUE INDEX `search_engine_short_unique` ON `search_engine` (`short`);
CREATE TABLE `section_collapse_state` (
	`user_id` text NOT NULL,
	`section_id` text NOT NULL,
	`collapsed` integer DEFAULT false NOT NULL,
	PRIMARY KEY(`user_id`, `section_id`),
	FOREIGN KEY (`user_id`) REFERENCES `user`(`id`) ON UPDATE no action ON DELETE cascade,
	FOREIGN KEY (`section_id`) REFERENCES `section`(`id`) ON UPDATE no action ON DELETE cascade
);
CREATE TABLE IF NOT EXISTS "user" (
	`id` text PRIMARY KEY NOT NULL,
	`name` text,
	`email` text,
	`email_verified` integer,
	`image` text,
	`password` text,
	`salt` text,
	`provider` text DEFAULT 'credentials' NOT NULL,
	`home_board_id` text,
    `mobile_home_board_id` text,
    `default_search_engine_id` text,
    `open_search_in_new_tab` integer DEFAULT true NOT NULL,
	`color_scheme` text DEFAULT 'dark' NOT NULL,
	`first_day_of_week` integer DEFAULT 1 NOT NULL,
	`ping_icons_enabled` integer DEFAULT false NOT NULL,
	FOREIGN KEY (`home_board_id`) REFERENCES `board`(`id`) ON UPDATE no action ON DELETE set null,
    FOREIGN KEY (`mobile_home_board_id`) REFERENCES `board`(`id`) ON UPDATE no action ON DELETE set null,
    FOREIGN KEY (`default_search_engine_id`) REFERENCES `search_engine`(`id`) ON UPDATE no action ON DELETE set null
);
CREATE TABLE IF NOT EXISTS "group" (
	`id` text PRIMARY KEY NOT NULL,
	`name` text NOT NULL,
	`owner_id` text,
    `home_board_id` text,
    `mobile_home_board_id` text,
	`position` integer NOT NULL,
	FOREIGN KEY (`owner_id`) REFERENCES `user`(`id`) ON UPDATE no action ON DELETE set null,
	FOREIGN KEY (`home_board_id`) REFERENCES `board`(`id`) ON UPDATE no action ON DELETE set null,
	FOREIGN KEY (`mobile_home_board_id`) REFERENCES `board`(`id`) ON UPDATE no action ON DELETE set null
);
CREATE UNIQUE INDEX `group_name_unique` ON `group` (`name`);
CREATE TABLE `item_layout` (
	`item_id` text NOT NULL,
	`section_id` text NOT NULL,
	`layout_id` text NOT NULL,
	`x_offset` integer NOT NULL,
	`y_offset` integer NOT NULL,
	`width` integer NOT NULL,
	`height` integer NOT NULL,
	PRIMARY KEY(`item_id`, `section_id`, `layout_id`),
	FOREIGN KEY (`item_id`) REFERENCES `item`(`id`) ON UPDATE no action ON DELETE cascade,
	FOREIGN KEY (`section_id`) REFERENCES `section`(`id`) ON UPDATE no action ON DELETE cascade,
	FOREIGN KEY (`layout_id`) REFERENCES `layout`(`id`) ON UPDATE no action ON DELETE cascade
);
CREATE TABLE `layout` (
	`id` text PRIMARY KEY NOT NULL,
	`name` text NOT NULL,
	`board_id` text NOT NULL,
	`column_count` integer NOT NULL,
	`breakpoint` integer DEFAULT 0 NOT NULL,
	FOREIGN KEY (`board_id`) REFERENCES `board`(`id`) ON UPDATE no action ON DELETE cascade
);
CREATE TABLE `section_layout` (
	`section_id` text NOT NULL,
	`layout_id` text NOT NULL,
	`parent_section_id` text,
	`x_offset` integer NOT NULL,
	`y_offset` integer NOT NULL,
	`width` integer NOT NULL,
	`height` integer NOT NULL,
	PRIMARY KEY(`section_id`, `layout_id`),
	FOREIGN KEY (`section_id`) REFERENCES `section`(`id`) ON UPDATE no action ON DELETE cascade,
	FOREIGN KEY (`layout_id`) REFERENCES `layout`(`id`) ON UPDATE no action ON DELETE cascade,
	FOREIGN KEY (`parent_section_id`) REFERENCES `section`(`id`) ON UPDATE no action ON DELETE cascade
);
CREATE TABLE IF NOT EXISTS "item" (
	`id` text PRIMARY KEY NOT NULL,
	`board_id` text NOT NULL,
	`kind` text NOT NULL,
	`options` text DEFAULT '{"json": {}}' NOT NULL,
	`advanced_options` text DEFAULT '{"json": {}}' NOT NULL,
	FOREIGN KEY (`board_id`) REFERENCES `board`(`id`) ON UPDATE no action ON DELETE cascade
);
CREATE TABLE IF NOT EXISTS "section" (
	`id` text PRIMARY KEY NOT NULL,
	`board_id` text NOT NULL,
	`kind` text NOT NULL,
	`x_offset` integer,
	`y_offset` integer,
	`name` text, `options` text DEFAULT '{"json": {}}',
	FOREIGN KEY (`board_id`) REFERENCES `board`(`id`) ON UPDATE no action ON DELETE cascade
);
CREATE TABLE `trusted_certificate_hostname` (
	`hostname` text NOT NULL,
	`thumbprint` text NOT NULL,
	`certificate` text NOT NULL,
	PRIMARY KEY(`hostname`, `thumbprint`)
);
CREATE TABLE `cron_job_configuration` (
	`name` text PRIMARY KEY NOT NULL,
	`cron_expression` text NOT NULL,
	`is_enabled` integer DEFAULT true NOT NULL
);

-- Drizzle migration records (marks migrations as complete)
INSERT INTO __drizzle_migrations VALUES(NULL,'c6fd51d50bbe0a63eaab178e83dc81b202a9b6eb5fe714abfb8a1c19a45b7a44',1715334238443);
INSERT INTO __drizzle_migrations VALUES(NULL,'058465bfa0947ad8894abf2a20dcf4976b896978e7a74faa805e06055d852fc2',1715871797713);
INSERT INTO __drizzle_migrations VALUES(NULL,'70cc9f161df3df995279ac89f3df957669047afa59f55cb2a0e6723f3bee4c3d',1715973963014);
INSERT INTO __drizzle_migrations VALUES(NULL,'10ccb5e8f52c0aa600c653d002e7d22090dd3e0ea70d13285c0aacb8ca655bfb',1716148434186);
INSERT INTO __drizzle_migrations VALUES(NULL,'a380540721b601bee0317d30272a23cf8d4a8955413d4d8ec6232ca516097e05',1720036615408);
INSERT INTO __drizzle_migrations VALUES(NULL,'f459640296a99c99f9d62f971e66e7a81804257140f7d0414b54deac5acd1deb',1722014142492);
INSERT INTO __drizzle_migrations VALUES(NULL,'cbf3736bed4b6966aa0cf04ef56f879f22dba6305fabfde94224ab5432ee413c',1722517033483);
INSERT INTO __drizzle_migrations VALUES(NULL,'721592bdc44fdff9efa3234f8d7172ca1a61d3aff5ff3fc5725b0c6df23839c6',1723746828385);
INSERT INTO __drizzle_migrations VALUES(NULL,'6de721f09f78dad924abb9f5f4328dae76a316914f9b5f04570033acbd86ad54',1727526190343);
INSERT INTO __drizzle_migrations VALUES(NULL,'3688327ce98d497d7684bca6de72ecf2df6a91d4400a6559674cb4d9ec60e2ef',1728074724956);
INSERT INTO __drizzle_migrations VALUES(NULL,'1375278b167980e9cfab9252e7e509add547d8465875b8f7f2d814e68b98dea1',1728142590232);
INSERT INTO __drizzle_migrations VALUES(NULL,'db7cd838e954be9cf9853187d77a83920663589094399ff00f05f29393c80058',1728490026154);
INSERT INTO __drizzle_migrations VALUES(NULL,'ba5ea9ed055770015302e46411b36104060e227117a6e09625494e75e3e62836',1729348200091);
INSERT INTO __drizzle_migrations VALUES(NULL,'28a87e76d5726e3e6c32c85e2ab8f345b47878c35c7d70f8353f19607c049adb',1729369389386);
INSERT INTO __drizzle_migrations VALUES(NULL,'3e18defeed7f3e3b07db1fcc3441ddf184cdd814fa61fd0b0a061360859a0bff',1729524387583);
INSERT INTO __drizzle_migrations VALUES(NULL,'a645a5bb21b331c51b38e8ca4cc053f9d1ee07bc343b93687212680c6142400b',1730653336134);
INSERT INTO __drizzle_migrations VALUES(NULL,'26a9895c88eb9ac339640de8da7d76b74f81017aa51ec95fbeb8185f717abe8a',1732210918783);
INSERT INTO __drizzle_migrations VALUES(NULL,'f0eca4ae890a552231b1906e9e3bb4664000ee3f6d2871c84025e86576375559',1733777395703);
INSERT INTO __drizzle_migrations VALUES(NULL,'798af2ff160a9193528328341327655a2a8ff731c90af1372490259830b7468b',1735593831501);
INSERT INTO __drizzle_migrations VALUES(NULL,'0e3d2739b77c0bf0bc78d587e5b777feb2fd76430033bb30ddef9c1d42318cee',1735651175378);
INSERT INTO __drizzle_migrations VALUES(NULL,'d6860fd993742cdb7d12c0ad8be5beeb5e6d81b7fd9a900d89770fce9a480a38',1736510755691);
INSERT INTO __drizzle_migrations VALUES(NULL,'04b12c3285cec666f61e47684c22ef90e551b21de692a5bac08878e782b44afe',1737883733050);
INSERT INTO __drizzle_migrations VALUES(NULL,'560b656f92946b97c7ed5aeb843912f1d3050bec8ed32a0c69298b7a26ea2f5c',1737927609085);
INSERT INTO __drizzle_migrations VALUES(NULL,'9086b777a1ea9346ac3213e7281a325330c99764dbb7319d7dd7c2d526209bfc',1738686324915);
INSERT INTO __drizzle_migrations VALUES(NULL,'0b4404d37e81c6770bc73795e3f93b10e7ceaf94633bf3ed54d1029418a91b4e',1738961178990);
INSERT INTO __drizzle_migrations VALUES(NULL,'62fede19625d4f74e79b84cae992abedbc65d54786f4aae272bac629c1013ff2',1739468826756);
INSERT INTO __drizzle_migrations VALUES(NULL,'a0f2add9ef93d36b90055049b8147753d58246c44f719b5ebcc7f6464b859378',1739907755789);
INSERT INTO __drizzle_migrations VALUES(NULL,'21ca1fa3959681191bcd735068b3fb2efd5cd8d1c7da29dd6cc2ca00365092a8',1739915486467);
INSERT INTO __drizzle_migrations VALUES(NULL,'03a502c9f0716354196180af98cd506182d1dbfb6480c6d26bd94d76375fe5a4',1740086746417);
INSERT INTO __drizzle_migrations VALUES(NULL,'17f2e70f28737ee06bb02ed3044cce54b9c3cf2c740dfaa50b2c6d5e38023b54',1740255687392);
INSERT INTO __drizzle_migrations VALUES(NULL,'c25e11095c7118ad7d555db32d9885b509a203592f341302a8b011c5908bc6b2',1740255968549);
INSERT INTO __drizzle_migrations VALUES(NULL,'55979c264bda530a9a03b35fa28240aa842e96c898ddb16aff8ceebadbae2b70',1740784849045);
INSERT INTO __drizzle_migrations VALUES(NULL,'946f889f8e28301fbeba6ec5ffb4ef7dd6de87354040dca440b1946bd8cc7dbd',1746821779051);
INSERT INTO __drizzle_migrations VALUES(NULL,'d7a634088f188021db0d963eb6340d23d8ff3091d3c7b45ea1f973e3082a4f9f',1750014001941);
INSERT INTO __drizzle_migrations VALUES(NULL,'54300d3a35b8a832d98d5c810e1712bf9d776290a678fa92db303affab1963ae',1760968503571);

-- Default icon repositories
INSERT INTO iconRepository VALUES('dzk9jjty2x565hqeq8sbx14k','homarr-labs/dashboard-icons');
INSERT INTO iconRepository VALUES('twu7828fkvri9qqul6rmubws','selfhst/icons');
INSERT INTO iconRepository VALUES('v1w9kv782o9m2ha4fyumwk0z','simple-icons/simple-icons');
INSERT INTO iconRepository VALUES('ib0rzgpbubtud3hazypdazzi','PapirusDevelopmentTeam/papirus-icon-theme');
INSERT INTO iconRepository VALUES('dv2hl053z8f1dhx5g76edm1u','loganmarchione/homelab-svg-assets');
INSERT INTO iconRepository VALUES('vgqigu9ankz9db88oe0t5bqo','local');

-- Default groups (everyone and admins)
INSERT INTO "group" VALUES('h74cx06xcpojc7ioje321r0q','everyone',NULL,NULL,NULL,-1);
INSERT INTO "group" VALUES('z4qbfvum6cs94sr6s5pslxq6','admins',NULL,NULL,NULL,0);

-- Admins group gets admin permission
INSERT INTO groupPermission VALUES('z4qbfvum6cs94sr6s5pslxq6','admin');

-- SEED DATA MARKERS (to be replaced by Python generator)
-- {{ONBOARDING}}
-- {{USER}}
-- {{API_KEY}}
-- {{SERVER_SETTINGS}}
-- {{GROUP_MEMBERS}}

COMMIT;
