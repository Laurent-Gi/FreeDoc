# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Pour créer des adresses des noms des adresses email...
require 'faker'
require 'time'


# 1 On nettoie la base au cas où il reste des choses...
# -----------------------------------------------------

Doctor.destroy_all
Patient.destroy_all
Appointment.destroy_all
City.destroy_all
#JoinTableSpecialtyDoctor.destroy_all

# Renseignons des paramètres pour ajuster si nécessaire :
# -------------------------------------------------------
number_of_city= 10
number_of_doctor=20
number_of_patient=80
number_of_appointment=150
# Tableau de spécialités à définir
specialties =["Cardiology", "Generalist", "Surgery", "Gastroenterologic surgery", "Neurology", "Stomatology", "Plastic surgery", "Immunology", "Neuropsychiatry", "Endocrinology"]
doctors  = []
patients = []
cities   = []



#2 On va créer des éléments...
#  ----------------------------
# if you need help to modify : https://github.com/faker-ruby/faker/blob/master/doc/default/address.md

# Les villes :
#Seed des 20 villes
number_of_city.times do |n|
  city = City.create(name: Faker::Address.city)
  cities << city
end
puts "#{number_of_city} cities has been created"

# Les docteurs (la spécialité suivra)
number_of_doctor.times do |n|
  doctor = Doctor.create(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, zip_code: Faker::Address.zip_code)
  doctor.specialty = specialties.sample # add specialty to doctor
  doctor.city = cities.sample # add a city to doctor
  doctor.save
  doctors << doctor
  print "."
  print "Doctor number #{n} created in database" if n%10 == 0 # Message tous les 10
end
puts "Doctors, ok " + "-="*30

# Les Patients :
number_of_patient.times do |n|
  patient = Patient.create(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, city: cities.sample)
  # patient.city = cities.sample # add a city to patient
  # patient.save
  patients << patient
  print "."
  print "Patient number #{n} created in database" if n%20 == 0 # Message tous les 20
end
puts "Patients, ok " + "-="*30


# On va créer des rendez-vous entre deux dates aléatoirement... des rdv passés et des futurs
t_past = Time.parse("2020-01-30 14:00:00")
t_future = Time.parse("2021-01-31 14:00:00")
number_of_appointment.times do |n|
  city=cities.sample #chose a city
  appointment = Appointment.create(
    doctor_id: doctors[rand(0..number_of_doctor-1)].id,
    patient_id: patients[rand(0..number_of_patient-1)].id,
    date: rand(t_past..t_future),
    city: city)
  print "."
  print "Appointment number #{n} created in database" if n%50 == 0 # Message tous les 50
end
puts "Appointments, ok " + "-="*28

puts "#{number_of_doctor} doctors created, #{number_of_patient} patients created, and #{number_of_appointment} appointments generated in the database."
