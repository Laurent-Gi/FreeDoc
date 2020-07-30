class Doctor < ApplicationRecord
  # Un docteur peut avoir plusieurs rendez-vous ;
  has_many :appointments
  # Un docteur peut avoir plusieurs patients, à travers les rendez-vous ;
  has_many :patients, through: :appointments
  # Ajout de la vile... appartient à la ville :
  belongs_to :city, optional: true

end
