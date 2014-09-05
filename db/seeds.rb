# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
# Episodes

# Roles
Role.create(:name => "organizer")
admin_role = Role.create(:name => "admin")
# Uncomment these lines to create an initial admin user
# admin_user = User.create(:name => "admin", :email => "admin@example.org")
# admin_user.roles = [admin_role]
