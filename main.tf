locals {

  defaults = {
    label_order = ["environment", "project", "workload", "type", "attributes"]
    delimiter   = "-"
    tf_config   = ""
    replacement = ""
    # The `sentinel` should match the `regex_replace_chars`, so it will be replaced with the `replacement` value
    sentinel   = "~"
    attributes = [""]
  }

  # The values provided by variables superceed the values inherited from the context

  enabled             = var.enabled
  regex_replace_chars = coalesce(var.regex_replace_chars, var.context.regex_replace_chars)

  environment        = lower(replace(coalesce(var.environment, var.context.environment, local.defaults.sentinel), local.regex_replace_chars, local.defaults.replacement))
  project            = lower(replace(coalesce(var.project, var.context.project, local.defaults.sentinel), local.regex_replace_chars, local.defaults.replacement))
  workload           = lower(replace(coalesce(var.workload, var.context.workload, local.defaults.sentinel), local.regex_replace_chars, local.defaults.replacement))
  type               = lower(replace(coalesce(var.type, var.context.type, local.defaults.sentinel), local.regex_replace_chars, local.defaults.replacement))
  delimiter          = coalesce(var.delimiter, var.context.delimiter, local.defaults.delimiter)
  tf_config          = replace(coalesce(var.tf_config, var.context.tf_config, local.defaults.sentinel), local.regex_replace_chars, local.defaults.replacement)
  label_order        = length(var.label_order) > 0 ? var.label_order : (length(var.context.label_order) > 0 ? var.context.label_order : local.defaults.label_order)
  additional_tag_map = merge(var.context.additional_tag_map, var.additional_tag_map)

  # Merge attributes
  attributes = compact(distinct(concat(var.attributes, var.context.attributes, local.defaults.attributes)))

  tags = merge(var.context.tags, local.generated_tags, var.tags)

  tags_as_list_of_maps = flatten([
    for key in keys(local.tags) : merge(
      {
        key   = key
        value = local.tags[key]
    }, var.additional_tag_map)
  ])

  tags_context = {
    # For AWS we need `Name` to be disambiguated sine it has a special meaning
    environment = local.environment
    project     = local.project
    workload    = local.workload
    name        = local.id
    terraform   = local.tf_config
    type        = local.type
    attributes  = local.id_context.attributes
  }

  generated_tags = { for l in keys(local.tags_context) : title(l) => local.tags_context[l] if length(local.tags_context[l]) > 0 }

  id_context = {
    environment = local.environment
    project     = local.project
    workload    = local.workload
    type        = local.type
    attributes  = lower(replace(join(local.delimiter, local.attributes), local.regex_replace_chars, local.defaults.replacement))
  }

  labels = [for l in local.label_order : local.id_context[l] if length(local.id_context[l]) > 0]

  id = lower(join(local.delimiter, local.labels))

  # Context of this label to pass to other label modules
  output_context = {
    enabled             = local.enabled
    environment         = local.environment
    project             = local.project
    workload            = local.workload
    type                = local.type
    attributes          = local.attributes
    tags                = local.tags
    delimiter           = local.delimiter
    tf_config           = local.tf_config
    label_order         = local.label_order
    regex_replace_chars = local.regex_replace_chars
    additional_tag_map  = local.additional_tag_map
  }

}
