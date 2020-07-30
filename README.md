# README

This README would normally document whatever steps are necessary to get the
application up and running.

* Ruby version : 2.7.1

* Rails 5.2.4.2

Lancement :

Aller à la racine (freedoc chez moi) là ou se trouve le Gemfile

$ bundle install

au choix :

execution du seed.rb :

$ rails db:seed

puis allez dans la console pour tester

$ rails console



###  A noter que mon Gemfile a été enrichi comme ci-dessous :
# Gemfile adds 
gem 'tzinfo-data', '>= 1.2016.7'

# gem added specialy for this project 
gem 'table_print'
gem 'faker'


### VOICI CE QUE J'AI FAIT PAS A PAS :

#1 création de l'environnement :
rbenv exec rails _5.2.4.2_ new freedoc

#2 on va dans le répertoire rails "freedoc"
cd freedoc

#3 modif/ajout dans le Gemfile :

gem 'tzinfo-data', '>= 1.2016.7'
gem 'table_print'
gem 'faker'

#4 bundle install
bundle install


#5 Création des modèles :

# Dans l'esprit, on va agir sur tables et medèle :
# 1 -Faire la migration pour créer les trois tables (patients, doctors et la table intermédiaire), et insérer les foreign keys aux bons endroits ;
# 2 -Créer les models et leur ajouter les liens grâce aux lignes has_many, belongs_to, etc.
On va donc essyer comme d'hab de tout faire en une fois en créant modèles + table et en ajoutant les liens AVANT de "rails db:migrate"


#rails generate model Doctor first_name:string last_name:string specialty:string zip_code:string

(un model Doctor, qui a comme attributs :
un first_name, qui est un string
un last_name, qui est un string
un specialty, qui est un string
un zip_code, qui est un string)


#rails generate model Patient first_name:string last_name:string

(un model Patient, qui a comme attributs :
un first_name, qui est un string
un last_name, qui est un string)


#rails generate model Appointment date:datetime

(un model Appointment, qui a comme attributs :
un date, qui est un datetime)

#6 Création des liens dans la table typée "Join-table" Appointment dans CreateAppointments : create_appointments.rb :
# C'est dans db/migrate/2020xxxxxxx_create_appointments.rb

    t.belongs_to :doctor, index: true
    t.belongs_to :patient, index: true

en plus de 

    create_table :appointments do |t|
      t.belongs_to :doctor, index: true
      t.belongs_to :patient, index: true
      t.datetime :date

      t.timestamps
    end


#6-bis (Si les tables avaient déjà une existence : On aurait juste fait une migration)
# pas de create_table mais juste :
def change
  add_reference :appointments, :doctor, foreign_key: true
  add_reference :appointments, :patient, foreign_key: true
end


#7 Lier les MODEL entre eux :  On ajoute les liens grâce aux lignes has_many, belongs_to, etc. DANS Appointment
# ça se passe dans app/models/appointment.rb /doctor.rb /patient.rb
Un rendez-vous appartient à un docteur ;  belongs_to
Un rendez-vous appartient à un patient ;
Un docteur peut avoir plusieurs rendez-vous ;   has_many
Un docteur peut avoir plusieurs patients, à travers les rendez-vous ;   has_many through
Un patient peut avoir plusieurs rendez-vous ;
Un patient peut avoir plusieurs docteurs, à travers les rendez-vous.

# appointment.rb
class Appointment < ApplicationRecord
  # Un rendez-vous appartient à un docteur ;
  belongs_to :doctor
  # Un rendez-vous appartient à un patient ;
  belongs_to :patient
end

# doctor.rb
class Doctor < ApplicationRecord
  # Un docteur peut avoir plusieurs rendez-vous ;
  has_many :appointments
  # Un docteur peut avoir plusieurs patients, à travers les rendez-vous ;
  has_many :patients, through: :appointments
end

#patient.rb
class Patient < ApplicationRecord
  # Un patient peut avoir plusieurs rendez-vous ;
  has_many :appointments
  # Un patient peut avoir plusieurs docteurs, à travers les rendez-vous.
  has_many :doctors, through: :appointments
end


# On fait un migrate !!!

rails db:migrate

puis on vérifie l'état

rails db:migrate:status

database: /home/saives/THP-PROJECT/S5/J4/freedoc/db/development.sqlite3

 Status   Migration ID    Migration Name
--------------------------------------------------
   up     20200730091022  Create doctors
   up     20200730091418  Create patients
   up     20200730091439  Create appointments


# Test dans la console en mode sandbox (pas de sauvegarde des modif après la sortie)
# ------------------------------------

d = Doctor.create

p = Patient.create

a = Appointment.create
renvoie un ROLLBACK (normal car il y a besoin d'un patient et d'un docteur pour la création d'un rdv)

a = Appointment.create(doctor: d, patient: p)

>a.doctor
#=> on obtient en retour le docteur "d" créé plus haut. Cool

>a.patient
#=> on obtient en retour le patient "p" créé plus haut. Cool

>d.patients
#=> on obtient en retour un array contenant le patient "p" créé plus haut. Cool

>p.doctors
#=> on obtient en retour un array contenant le doctor "d" créé plus haut. Cool


# On peut s'attaquer au seed.rb
# -----------------------------

require 'faker'
require 'time' # j'utilise Time.parse

Tout ceci est déjà très très long !!!!


# On veut ajouter city :


### On va donc créer un model City - /!\ DANS L'ORDRE


# 1 On ajoute des champs cities aux doctor, patient, appointment

##rails generate model City name:string

(un model City, qui a comme attributs :
un name, qui est un string)


# On crée les modèles 
class City < ApplicationRecord
  has_many :doctors
  has_many :patients
  has_many :appointments
end

class Appointment < ApplicationRecord

  belongs_to :doctor
  belongs_to :patient
  belongs_to :city, optional: true

end

class Doctor < ApplicationRecord

  has_many :appointments
  has_many :patients, through: :appointments
  belongs_to :city, optional: true

end

class Patient < ApplicationRecord

  has_many :appointments
  has_many :doctors, through: :appointments
  belongs_to :city, optional: true

end

# Création des liens de dépendance de table :

    t.belongs_to :doctor, index: true
    t.belongs_to :patient, index: true
    t.belongs_to :appointments, index: true


# LA SUITE...

## Suppression de la column specialty

class DeleteDoctorSpecialtyColumn < ActiveRecord::Migration[5.2]
  def change
    remove_column :doctors, :specialty, :string #suppression de la colonne specialty de la table doctors
  end
end


## Ajout de 2 modèles


$ rails generate model Specialty name:string

$ rails generate model JoinTableSpecialtyDoctor


On met à jours les tables :

class CreateSpecialties < ActiveRecord::Migration[5.2]
  def change
    create_table :specialties do |t|
      t.string :name

      t.timestamps
    end
  end
end

class CreateJoinTableSpecialtyDoctors < ActiveRecord::Migration[5.2]
  def change
    create_table :join_table_specialty_doctors do |t|
      t.belongs_to :doctor, index: true
      t.belongs_to :specialty, index: true
      t.timestamps
    end
  end
end



Et les modeles:

class Specialty < ApplicationRecord
  has_many :join_table_specialty_doctor
  has_many :doctors, through: :join_table_specialty_doctor
end

Doctor MAJ:
  has_many :join_table_specialty_doctor
  has_many :specialties, through: :join_table_specialty_doctor


class JoinTableSpecialtyDoctor < ApplicationRecord
  belongs_to :doctor
  belongs_to :specialty
end


## Mise à jour du fichier seed.rb !

## Les tests dans la console sont concluants !!!