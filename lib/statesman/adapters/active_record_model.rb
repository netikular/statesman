module Statesman
  module Adapters
    module ActiveRecordModel
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def in_state(*states)
          includes(transition_name)
            .joins(transition_name)
            .joins(transition_join)
            .where("#{transition_name}.to_state" => states.map(&:to_s))
            .where("transition2.id" => nil)
            .references(transition_name)
        end

        def not_in_state(*states)
          includes(transition_name)
            .joins(transition_name)
            .joins(transition_join)
            .where("#{transition_name}.to_state NOT IN (?)", states.map(&:to_s))
            .where("transition2.id" => nil)
            .references(transition_name)
        end

        private

        def transition_class
          raise NotImplementedError, "A transition_class method should be " +
                                     "defined on the model"
        end

        def transition_name
          transition_class.table_name.to_sym
        end

        def model_foreign_key
          reflections[transition_name].foreign_key
        end

        def transition_join
          "LEFT OUTER JOIN #{transition_name} transition2
             ON transition2.#{model_foreign_key} = #{table_name}.id
             AND transition2.sort_key > #{transition_name}.sort_key"
        end
      end
    end
  end
end
