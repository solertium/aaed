class SurveyGroundSampleCountStratum < ActiveRecord::Base
  include Stratum

  # All normal attributes of Stratum models are mass-assignable
  attr_protected :created_at, :updated_at

  validates_presence_of :population_estimate

  belongs_to :survey_ground_sample_count

  class SurveyGroundSampleCountStratumValidator < ActiveModel::Validator
    def validate(record)
      unless record.population_no_precision_estimate_available
        some_precision = false
        [:population_variance,
         :population_standard_error,
         :population_t,
         :population_degrees_of_freedom,
         :population_confidence_limits].each do |field|
          value = record.send field
          unless value.nil?
            some_precision = true
            break
          end
        end
        unless some_precision
          record.errors[:population_no_precision_estimate_available] << "must be checked if no other precision information is available"
        end
      end
    end
  end

  validates_with SurveyGroundSampleCountStratumValidator

end
