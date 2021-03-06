desc 'setup building'
task setup_building: :environment do
  landlord = User.find_by_email('maurice@upstairs.io')
  building = Building.find_by_slug('401-43rd-ave-san-francisco-ca-94121-usa')
  landlord.make_landlord(building)
  landlord = landlord.profile_building_ownership_declared!
  manager = User.find_by_email('jerry@upstairs.io')
  manager.make_manager(building)

  ['jane@upstairs.io', 'mark@upstairs.io', 'katy@upstairs.io'].each do |email|
    user = User.find_by_email(email)
    user.make_tenant(building)
  end
end

desc 'setup building'
task setup_units: :environment do
  Membership.tenant.each_with_index do |membership, i|
    building = membership.building
    user = membership.user
    unit = building.units.create(name: "unit #{i}")
    Tenancy.create!(user: membership.user, building: building, unit: unit)
  end
end
