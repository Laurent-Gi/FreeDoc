class Specialty < ApplicationRecord
  has_many :join_table_specialty_doctor
  has_many :doctors, through: :join_table_specialty_doctor
end