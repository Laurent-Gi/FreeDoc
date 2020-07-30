class Appointment < ApplicationRecord
  # Un rendez-vous appartient à un docteur :
  belongs_to :doctor
  # Un rendez-vous appartient à un patient :
  belongs_to :patient
  # Ajout de la vile... appartient à la ville :

  belongs_to :city, optional: true

end
