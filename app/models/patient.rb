class Patient < ApplicationRecord
  # Un patient peut avoir plusieurs rendez-vous ;
  has_many :appointments
  # Un patient peut avoir plusieurs docteurs, à travers les rendez-vous.
  has_many :doctors, through: :appointments

  belongs_to :city, optional: true

end
