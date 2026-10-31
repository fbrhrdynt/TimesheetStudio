CREATE TABLE `timesheet_events` (
	`id` text PRIMARY KEY NOT NULL,
	`timesheet_id` text NOT NULL,
	`user_id` text NOT NULL,
	`kind` text NOT NULL,
	`reason` text NOT NULL,
	`from_status` text NOT NULL,
	`to_status` text NOT NULL,
	`snapshot` text NOT NULL,
	`created` integer NOT NULL
);
--> statement-breakpoint
CREATE TABLE `timesheets` (
	`id` text PRIMARY KEY NOT NULL,
	`user_id` text NOT NULL,
	`start` text NOT NULL,
	`end` text NOT NULL,
	`json` text NOT NULL,
	`status` text DEFAULT 'draft' NOT NULL,
	`editing` integer DEFAULT 0 NOT NULL,
	`edit_reason` text DEFAULT '' NOT NULL,
	`revision` integer DEFAULT 0 NOT NULL,
	`created` integer NOT NULL,
	`updated` integer NOT NULL
);
