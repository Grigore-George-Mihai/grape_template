# frozen_string_literal: true

class GrapeResourceGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("templates", __dir__)

  class_option :version, type: :string, default: "v1", desc: "API version"

  # Define attribute argument
  argument :attributes, type: :array, default: [], banner: "field:type field:type"

  def create_api
    template "resource.rb.tt", "app/api/#{version}/resources/#{file_name.pluralize}.rb"
  end

  def create_entity
    template "entity.rb.tt", "app/api/#{version}/entities/#{file_name.singularize}_entity.rb"
  end

  def create_spec
    template "resource_spec.rb.tt", "spec/api/#{version}/resources/#{file_name.pluralize}_spec.rb"
  end

  def mount_api
    file_path = "app/api/#{version}/api.rb"
    mount_line = "    mount #{version.camelize}::Resources::#{class_name.pluralize}\n"

    # Only inject if the mount line is not already present
    return if File.readlines(file_path).grep(/#{mount_line.strip}/).any?

    inject_into_file file_path,
                     after: "# Mount endpoints - Used by generator do not delete\n" do
      mount_line
    end
  end

  def add_model_to_swagger
    file_path = "app/api/api_root.rb"
    model_line = "      #{version.camelize}::Entities::#{class_name}Entity,"

    # Inject the entity into the Swagger models array if it's not already there
    return if File.readlines(file_path).grep(/#{model_line.strip}/).any?

    inject_into_file file_path, after: "models: [" do
      "\n#{model_line}"
    end
  end

  def ask_and_generate_model
    say("Do you want to generate the #{class_name} model? (yes/no)", :yellow)
    response = ask("Enter 'yes' to generate the model or 'no' to skip:")

    if response.downcase == "yes"
      # Prepare the default attributes
      default_attributes = attributes.map { |attr| "#{attr.name}:#{attr.type}" }.join(" ")
      say("Default attributes: #{default_attributes}", :green)

      # Ask the user if they want to add more attributes
      additional_attributes = ask("Enter additional attributes or press Enter to use only the default (#{default_attributes}):")

      # Combine default attributes with any additional ones provided by the user
      model_attributes = [default_attributes, additional_attributes].reject(&:empty?).join(" ")

      generate_model_command = "rails g model #{class_name} #{model_attributes}"

      say("Running: #{generate_model_command}", :green)
      system(generate_model_command)
    else
      say("Skipping model generation.", :red)
    end
  end

  private

  def version
    options[:version]
  end

  def attribute_type_for_grape(type)
    {
      text: "String",
      decimal: "Float"
    }.fetch(type, type.to_s.camelize)
  end

  def default_value_for(attribute, context = :create)
    case attribute.type.to_s.downcase
    when "string", "text"
      context == :create ? "\"example_#{attribute.name}\"" : "\"updated_#{attribute.name}\""
    when "integer"
      context == :create ? "1" : "2"
    when "float", "decimal"
      context == :create ? "1.5" : "2.5"
    when "boolean"
      context == :create ? "true" : "false"
    when "date"
      context == :create ? "\"2023-01-01\"" : "\"2024-01-01\""
    when "datetime", "time"
      context == :create ? "\"2023-01-01T00:00:00Z\"" : "\"2024-01-01T00:00:00Z\""
    else
      "YOUR_VALUE_HERE"
    end
  end
end
