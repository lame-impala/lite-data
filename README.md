# Lite::Data
Easy definition of data classes with subclassing support 
and flexible constructor signatures.

## Overview
Closely follows the interface of Ruby 3.2's `Data` class, but adds:
- Subclassing capability
- Mixed positional and keyword arguments
- Module-based design for including in existing classes

## Class definition
### Defining a data class
Use `Lite::Data.define(klass, args:, kwargs:)` with arrays for positional 
and keyword parameters. The following declaration generates a module with
necessary instance methods and includes it in the target class:

```ruby rspec definition_superclass
class Foo
  Lite::Data.define(self, args: [:foo])
end

expect(Foo.new('FOO').foo).to eq('FOO')
```

The same works when extending existing data classes:
```ruby rspec definition_subclass
class Bar < Foo
  Lite::Data.define(self, kwargs: [:bar])
end

expect(Bar.new('FOO', bar: 'BAR').bar).to eq('BAR')
```

### Argument positioning in subclasses
By default, new positional arguments are added at the start. Use `:'*'` 
as a placeholder to control positioning:

```ruby rspec definition_argument_positioning
class Bax < Bar
  Lite::Data.define(self, args: [:'*', :bax])
end

expect(Bax.new('FOO', 'BAX', bar: 'BAR').bax).to eq('BAX')
```

## Generated methods
Classes automatically receive:
- **Comparison**: `==`, `eql?`, `hash`
- **Cloning**: `with`
- **Introspection**: `deconstruct`, `deconstruct_keys`, `to_h`

### Destructuring order
The `deconstruct` method returns values in order of inheritance, 
each class contributes its members in order of definition, 
positional first:
```ruby rspec introspection_deconstruct
# inheritance chain: Bax < Bar < Foo
expect(Bax.new('FOO', 'BAX', bar: 'BAR').deconstruct)
  .to eq(%w[FOO BAR BAX])
```

# License
This library is published under MIT license
