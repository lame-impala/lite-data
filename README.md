# Lite::Data
Easy definition of data classes with subclassing support and flexible constructor signatures.

## Overview
Closely follows the interface of Ruby 3.2's `Data` class, but adds:
- Subclassing capability
- Mixed positional and keyword arguments
- Module-based design for including in existing classes

## Class definition
### Defining a data class
Use `Lite::Data.define(klass, args:, kwargs:)` with arrays for positional and keyword parameters:

```ruby rspec definition_superclass
class Foo
  Lite::Data.define(self, args: [:foo])
end

Foo.new('FOO').foo  # => 'FOO'
```

The same works when extending existing data classes:
```ruby rspec definition_subclass
class Bar < Foo
  Lite::Data.define(self, kwargs: [:bar])
end

Bar.new('FOO', bar: 'BAR').bar  # => 'BAR'
```

### Argument positioning in subclasses
By default, new positional arguments are added at the start. Use `:'*'` as a placeholder to control positioning:

```ruby rspec definition_argument_positioning
class Bax < Bar
  Lite::Data.define(self, args: [:'*', :bax])
end

Bax.new('FOO', 'BAX', bar: 'BAR').bax  # => 'BAX'
```

## Generated methods
Classes automatically receive:
- **Comparison**: `==`, `eql?`, `hash`
- **Pattern matching**: `deconstruct`, `deconstruct_keys`
- **Cloning**: `with`

# License
This library is published under MIT license
