module SQLParser

  module Statement

    class Node

      def accept(visitor)
        klass = self.class.ancestors.find do |ancestor|
          visitor.respond_to?("visit_#{demodulize(ancestor.name)}")
        end

        if klass
          visitor.__send__("visit_#{demodulize(klass.name)}", self)
        else
          raise "No visitor for #{self.class.name}"
        end
      end

      def to_sql
        SQLVisitor.new.visit(self)
      end

      private

      def demodulize(str)
        str.split('::')[-1]
      end

    end

    class Insert < Node

      def initialize(table_reference, column_list, in_value_list)
        @table_reference = table_reference
        @column_list = column_list
        @in_value_list = in_value_list
      end

      attr_accessor :table_reference
      attr_accessor :column_list
      attr_accessor :in_value_list

    end

    class DirectSelect < Node

      def initialize(query_expression, order_by, fetch_only = nil)
        @query_expression = query_expression
        @order_by = order_by
        @fetch_only = fetch_only
      end

      attr_accessor :query_expression
      attr_accessor :order_by
      attr_accessor :fetch_only

    end

    class Update < Node
      def initialize(table, assign_list, where)
        @table = table
        @assign_list = assign_list.flatten
        @where = where
      end

      attr_accessor :table
      attr_accessor :assign_list
      attr_accessor :where
    end

    class AssignColumn < Node
      def initialize(column, value)
        @column = column
        @value = value
      end

      attr_accessor :column
      attr_accessor :value
    end

    class OrderBy < Node

      def initialize(sort_specification)
        @sort_specification = Array(sort_specification)
      end

      attr_accessor :sort_specification

    end

    class FetchOnly < Node

      def initialize(offset, row_count)
        @offset = offset
        @row_count = row_count
      end

      attr_accessor :offset
      attr_accessor :row_count

    end

    class Subquery < Node

      def initialize(query_specification)
        @query_specification = query_specification
      end

      attr_accessor :query_specification

    end

    class Select < Node
      def initialize(list, table_expression = nil)
        @list = list
        @table_expression = table_expression
      end

      attr_accessor :list
      attr_accessor :table_expression

    end

    class SelectList < Node

      def initialize(columns)
        @columns = Array(columns)
      end

      attr_accessor :columns

    end

    class Distinct < Node
      def initialize(list)
        @list = list
      end

      attr_accessor :list
    end

    class All < Node
    end

    class TableExpression < Node

      def initialize(from_clause, where_clause = nil, group_by_clause = nil, having_clause = nil)
        @from_clause = from_clause
        @where_clause = where_clause
        @group_by_clause = group_by_clause
        @having_clause = having_clause
      end

      attr_accessor :from_clause
      attr_accessor :where_clause
      attr_accessor :group_by_clause
      attr_accessor :having_clause

    end

    class FromClause < Node

      def initialize(tables)
        @tables = Array(tables)
      end

      attr_accessor :tables

    end

    class OrderClause < Node

      def initialize(columns)
        @columns = Array(columns)
      end

      attr_accessor :columns

    end

    class OrderSpecification < Node

      def initialize(column)
        @column = column
      end

      attr_accessor :column

    end

    class Ascending < OrderSpecification
    end

    class Descending < OrderSpecification
    end

    class HavingClause < Node

      def initialize(search_condition)
        @search_condition = search_condition
      end

      attr_accessor :search_condition

    end

    class CaseClause < Node
      def initialize(value, branches, elsepart)
        @branches = branches
        @elsepart = elsepart
        @value = value
      end

      attr_accessor :value
      attr_accessor :branches
      attr_accessor :elsepart
    end

    class WhenClause < Node
      def initialize(condition, value)
        @condition = condition
        @value = value
      end

      attr_accessor :condition
      attr_accessor :value
    end

    class GroupByClause < Node

      def initialize(columns)
        @columns = Array(columns)
      end

      attr_accessor :columns

    end

    class WhereClause < Node

      def initialize(search_condition)
        @search_condition = search_condition
      end

      attr_accessor :search_condition

    end

    class On < Node

      def initialize(search_condition)
        @search_condition = search_condition
      end

      attr_accessor :search_condition

    end

    class SearchCondition < Node

      def initialize(left, right)
        @left = left
        @right = right
      end

      attr_accessor :left
      attr_accessor :right

    end

    class Using < Node

      def initialize(columns)
        @columns = Array(columns)
      end

      attr_accessor :columns

    end

    class Or < SearchCondition
    end

    class And < SearchCondition
    end

    class Exists < Node

      def initialize(table_subquery)
        @table_subquery = table_subquery
      end

      attr_accessor :table_subquery

    end

    class ComparisonPredicate < Node

      def initialize(left, right)
        @left = left
        @right = right
      end

      attr_accessor :left
      attr_accessor :right

    end

    class Is < ComparisonPredicate
    end

    class Like < ComparisonPredicate
    end

    class In < ComparisonPredicate
    end

    class InValueList < Node

      def initialize(values)
        @values = values
      end

      attr_accessor :values

    end

    class InColumnList < Node

      def initialize(columns)
        @columns = columns
      end

      attr_accessor :columns

    end

    class Between < Node

      def initialize(left, min, max)
        @left = left
        @min = min
        @max = max
      end

      attr_accessor :left
      attr_accessor :min
      attr_accessor :max

    end

    class GreaterOrEquals < ComparisonPredicate
    end

    class LessOrEquals < ComparisonPredicate
    end

    class Greater < ComparisonPredicate
    end

    class Less < ComparisonPredicate
    end

    class Equals < ComparisonPredicate
    end

    class Aggregate < Node

      def initialize(column)
        @column = column
      end

      attr_accessor :column

    end

    class FunctionCall < Node
      def initialize(name, argument)
        @name = name
        @argument = Array(argument)
      end

      attr_accessor :name
      attr_accessor :argument
    end

    class BooleanFunction < FunctionCall
    end

    class Sum < Aggregate
    end

    class Minimum < Aggregate
    end

    class Maximum < Aggregate
    end

    class Average < Aggregate
    end

    class Count < Aggregate
    end

    class JoinedTable < Node

      def initialize(left, right)
        @left = left
        @right = right
      end

      attr_accessor :left
      attr_accessor :right

    end

    class CrossJoin < JoinedTable
    end

    class QualifiedJoin < JoinedTable

      def initialize(left, right, search_condition)
        super(left, right)
        @search_condition = search_condition
      end

      attr_accessor :search_condition

    end

    class InnerJoin < QualifiedJoin
    end

    class LeftJoin < QualifiedJoin
    end

    class LeftOuterJoin < QualifiedJoin
    end

    class RightJoin < QualifiedJoin
    end

    class RightOuterJoin < QualifiedJoin
    end

    class FullJoin < QualifiedJoin
    end

    class FullOuterJoin < QualifiedJoin
    end

    class QualifiedColumn < Node

      def initialize(table, column)
        @table = table
        @column = column
      end

      attr_accessor :table
      attr_accessor :column

    end

    class Identifier < Node

      def initialize(name)
        @name = name
      end

      attr_accessor :name

    end

    class Table < Identifier
    end

    class Column < Identifier
    end

    class As < Node

      def initialize(value, column)
        @value = value
        @column = column
      end

      attr_accessor :value
      attr_accessor :column

    end

    class Arithmetic < Node

      def initialize(left, right)
        @left = left
        @right = right
      end

      attr_accessor :left
      attr_accessor :right

    end

    class Multiply < Arithmetic
    end

    class Divide < Arithmetic
    end

    class Add < Arithmetic
    end

    class Subtract < Arithmetic
    end

    class Unary < Node

      def initialize(value)
        @value = value
      end

      attr_accessor :value

    end

    class Not < Unary
    end

    class UnaryPlus < Unary
    end

    class UnaryMinus < Unary
    end

    class CurrentUser < Node
    end

    class True < Node
      def initialize()
        @value = true
      end
    end

    class False < Node
      def initialize()
        @value = false
      end
    end

    class Null < Node
    end

    class Literal < Node

      def initialize(value)
        @value = value
      end

      attr_accessor :value

    end

    class String < Literal
    end

    class ApproximateFloat < Node

      def initialize(mantissa, exponent)
        @mantissa = mantissa
        @exponent = exponent
      end

      attr_accessor :mantissa
      attr_accessor :exponent

    end

    class Float < Literal
    end

    class Integer < Literal
    end

    class Variable < Node
      def initialize(value)
        @value = value
      end

      attr_accessor :value
    end
  end
end
