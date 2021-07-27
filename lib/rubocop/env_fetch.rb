# https://github.com/rubocop/rubocop-rails/issues/306
module RuboCop
  module Cop
    module Style
      # Requires ENV calls to use fetch instead of brackets.
      #
      # @example
      #
      #   # bad
      #   ENV['something']
      #
      #   # good
      #   ENV.fetch('SOMETHING')
      #
      class EnvFetch < Base
        extend AutoCorrector

        def safe_autocorrect?
          false
        end

        MSG = 'ENV values should use fetch if they are required.'

        def_node_matcher :env_brackets?, <<~PATTERN
          (send (:const nil? :ENV) :[] (:str $_))
        PATTERN

        def on_send(node)
          env_brackets?(node) do |expression|
            add_offense(node) do |corrector|
              corrector.replace(node, node.source.sub(/ENV\[.*?\]/, "ENV.fetch(#{expression.inspect})"))
            end
          end
        end
      end
    end
  end
end
