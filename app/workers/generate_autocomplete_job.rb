# -*- encoding : utf-8 -*-
class GenerateAutocompleteJob
  @queue = :low

  def self.perform
    Autocomplete.perform
  end
end