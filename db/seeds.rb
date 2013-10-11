# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
# Events
Event.create(id: 1, name: "hackweek1", start: "2007-06-25", end: "2007-10-29")
Event.create(id: 2, name: "hackweek2", start: "2008-02-11", end: "2008-10-15")
Event.create(id: 3, name: "hackweek3", start: "2008-08-25", end: "2008-08-29")
Event.create(id: 4, name: "hackweek4", start: "2009-07-20", end: "2009-07-24")
Event.create(id: 5, name: "hackweek5", start: "2010-06-07", end: "2010-06-11")
Event.create(id: 6, name: "hackweek6", start: "2008-02-11", end: "2013-10-15")
Event.create(id: 7, name: "hackweek7", start: "2011-01-24", end: "2011-01-28")
Event.create(id: 8, name: "hackweek8", start: "2012-07-23", end: "2012-07-27")
Event.create(id: 9, name: "hackweek9", start: "2013-04-08", end: "2013-04-12")
Event.create(id: 10, name: "hackweek10", start: "2013-10-03", end: "2013-10-12")

# Roles
Role.create(:name => "organizer")
admin_role = Role.create(:name => "admin")
# Uncomment these lines to create an initial admin user
# admin_user = User.create(:name => "admin", :email => "admin@example.org")
# admin_user.roles = [admin_role]
