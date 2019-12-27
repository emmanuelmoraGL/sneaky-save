# frozen_string_literal: true

#--
# Copyright (c) 2011 {PartyEarth LLC}[http://partyearth.com]
# mailto:kgoslar@partyearth.com
#++
module SneakySave
  # Saves the record without running callbacks/validations.
  # Returns true if the record is changed.
  # @note - Does not reload updated record by default.
  #       - Does not save associated collections.
  #       - Saves only belongs_to relations.
  #
  # @return [false, true]
  def sneaky_save
    sneaky_create_or_update
  rescue ActiveRecord::StatementInvalid
    false
  end

  # Saves record without running callbacks/validations.
  # @see ActiveRecord::Base#sneaky_save
  # @return [true] if save was successful.
  # @raise [ActiveRecord::StatementInvalid] if saving failed.
  def sneaky_save!
    sneaky_create_or_update
  end

  protected

  def sneaky_create_or_update
    new_record? ? sneaky_create : sneaky_update
  end

  # Performs INSERT query without running any callbacks
  # @return [false, true]
  def sneaky_create
    attributes_values = sneaky_attributes_values
    new_id = self.class._insert_record(attributes_values)
    @new_record = false
    (self.id ||= new_id).present?
  end

  # Performs update query without running callbacks
  # @return [false, true]
  def sneaky_update
    return true if changes.empty?

    pk = self.class.primary_key
    original_id = changed_attributes.key?(pk) ? changes[pk].first : send(pk)

    changed_attributes = sneaky_update_fields

    !self.class.unscoped.where(pk => original_id)
         .update_all(changed_attributes).zero?
  end

  def sneaky_attributes_values
    attributes_with_values(attributes_for_create(attribute_names))
  end

  def sneaky_update_fields
    changes.keys.each_with_object({}) do |field, result|
      result[field] = read_attribute(field)
    end
  end

  def sneaky_connection
    self.class.connection
  end
end

ActiveRecord::Base.include SneakySave
