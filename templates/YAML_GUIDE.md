# YAML-Driven T-Driver Test Generation Guide

## Overview

The T-Driver YAML specification provides a structured way to define test requirements that Copilot can use to generate complete, framework-compliant tests.

## Files Included

### `tdriver_test_spec.yaml`
- **Purpose**: Complete YAML template for test specification
- **Usage**: Fill out with your requirements and provide to Copilot
- **Features**: Covers all test types, authentication, validation, and configuration

### `example_customer_api_spec.yaml` 
- **Purpose**: Fully filled-out example showing all features
- **Usage**: Reference for understanding YAML structure and options
- **Scenario**: Multi-transport customer API testing with authentication

## How to Use YAML Specifications

### Step 1: Choose Your Template
- For new tests: Use `tdriver_test_spec.yaml`
- For reference: Study `example_customer_api_spec.yaml`

### Step 2: Fill Out Requirements
```yaml
test_metadata:
  name: "my_pasoe_test"
  description: "Test PASOE REST API endpoints"
  type: "rest"
  
test_scenarios:
  rest:
    enabled: true
    endpoints:
      - method: "GET"
        path: "/api/data"
        expected_status: 200
```

### Step 3: Provide to Copilot
```
"Create a T-Driver test based on this YAML specification:
[paste your filled-out YAML content here]

Please follow T-Driver framework standards and use common_funs.sh functions."
```

## YAML Specification Features

### Test Types Supported
- **APSV**: AppServer transport testing
- **REST**: HTTP/REST API testing
- **SOAP**: SOAP web service testing  
- **WEB**: Web handler testing
- **Multi-transport**: Combined protocol testing

### Configuration Options
- **PASOE Instance**: Automatic instance creation and configuration
- **Authentication**: Bearer tokens, OAuth2, API keys
- **Validation**: Response patterns, performance checks, data integrity
- **File Generation**: Server procedures, clients, handlers

### Advanced Features
- **Custom Properties**: PASOE instance configuration
- **SSL Configuration**: Certificate handling
- **Performance Testing**: Response time validation
- **Data Management**: Test data setup and cleanup

## Example Copilot Interactions

### Basic REST API Test
```yaml
test_metadata:
  name: "product_api_test"
  type: "rest"
  
test_scenarios:
  rest:
    enabled: true
    endpoints:
      - method: "GET"
        path: "/products"
        expected_status: 200
```

### APSV Transport Test
```yaml
test_metadata:
  name: "order_processing_test"
  type: "apsv"
  
test_scenarios:
  apsv:
    enabled: true
    server_procedure:
      name: "process_order.p"
      outputs:
        - name: "order_result"
          type: "CHARACTER"
```

### Multi-Transport Test
```yaml
test_metadata:
  name: "comprehensive_api_test"
  type: "multi-transport"
  
test_scenarios:
  rest:
    enabled: true
    endpoints: [...]
  apsv:
    enabled: true
    server_procedure: [...]
  web:
    enabled: true
    handlers: [...]
```

## Benefits of YAML-Driven Approach

### For Developers
- **Structured Input**: Clear, organized requirement specification
- **Consistent Output**: Framework-compliant tests every time
- **Reusable Specs**: Save and modify YAML files for similar tests

### For Teams
- **Standardization**: Common format for test requirements
- **Documentation**: YAML serves as test specification document
- **Version Control**: Track requirement changes over time

### For Copilot
- **Better Context**: Structured input improves generation quality
- **Complete Information**: All requirements captured in one place
- **Validation**: Built-in validation criteria and success patterns

## Tips for Effective YAML Usage

1. **Start Simple**: Begin with basic test type, add complexity gradually
2. **Use Examples**: Reference `example_customer_api_spec.yaml` for guidance
3. **Be Specific**: Detailed specifications yield better test generation
4. **Include Validation**: Define clear success criteria and failure patterns
5. **Document Purpose**: Use description fields to explain test goals

The YAML specification system makes T-Driver test generation more predictable, structured, and maintainable while ensuring framework compliance!