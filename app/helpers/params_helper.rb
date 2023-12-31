module ParamsHelper
  ###
  # @param parameters [ActionController::Parameters]
  # @return [String]
  def params_as_hidden_fields(parameters)
    hidden_fields_hash(parameters).reduce(''.html_safe) do |html, (param, value)|
      if value.is_a?(Array)
        value.each do |v|
          html += hidden_field_tag(param, v)
        end
      else
        html += hidden_field_tag(param, value)
      end
      html
    end
  end

  ###
  # @param parameters [ActionController::Parameters]
  # @return [Hash]
  def hidden_fields_hash(parameters)
    parameters.each.reduce({}) do |acc, (param, value)|
      acc.merge(create_entries(param, value))
    end
  end

  ###
  # @param param [Symbol]
  # @param value [ActionController::Parameters, Array, String, Integer, Boolean]
  # @return [Hash]
  def create_entries(param, value, key = param.to_s, acc = {})
    case value
    when ActionController::Parameters
      value.each do |nested_key, nested_value|
        create_entries(nested_key, nested_value, key + "[#{nested_key}]", acc)
      end
    when Array
      acc[key + '[]'] = value
    else
      acc[key] = value
    end

    acc
  end
end
