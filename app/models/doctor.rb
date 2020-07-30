class Doctor < ApplicationRecord
  # Un docteur peut avoir plusieurs rendez-vous ;
  has_many :appointments
  # Un docteur peut avoir plusieurs patients, à travers les rendez-vous ;
  has_many :patients, through: :appointments
  # Ajout de la vile... appartient à la ville :
  belongs_to :city, optional: true
  # Ajout de la join table et des spécialités à travers la joint table
  has_many :join_table_specialty_doctor
  has_many :specialties, through: :join_table_specialty_doctor

end
