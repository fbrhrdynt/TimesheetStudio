CREATE INDEX `events_owner_sheet` ON `timesheet_events` (`user_id`,`timesheet_id`);--> statement-breakpoint
CREATE UNIQUE INDEX `timesheets_user_period` ON `timesheets` (`user_id`,`start`,`end`);