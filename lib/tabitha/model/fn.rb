# TODO: Turn this to a 'fn' class, it is part of an `impl` class.
class API
  attr_reader :location, :trait, :name, :params, :return_type

  def initialize(location, name, params, return_type, trait, mod, vis)
    @location = location; @name = name;
    @params = params; @return_type = return_type; @trait = trait
    @mod = mod; @vis = vis
  end

  def returns?
    !@return_type.nil?
  end

  def implements_trait?
    !@trait.nil?
  end

  def to_uml
    ret = "#{@name}#{@params}"
    ret = "#{@trait}::#{ret}" if self.implements_trait?
    ret = "#{ret} -> #{@return_type}" if self.returns?
    ret
  end
end
