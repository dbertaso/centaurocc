module ActiveRecord
  class Errors
    def add_errors(_errors)
      _errors.each() do |a, m| 
        self.add(a, m)
      end
      self.add_to_base(_errors.on_base)
    end
    def add_errors_with_raise(_errors)
      self.add_errors(_errors)
      raise "Ocurrieron Errores"
    end
  end
end