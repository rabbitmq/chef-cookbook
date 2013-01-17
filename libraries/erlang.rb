class Object
  def to_erl(tab, indent)
    prefix = tab * (indent+1)
    newLine = "\n" + prefix
    case self
    when Hash
      if self.size > 0
      "[" + newLine + 
        self.map {|(k,v)|
          val = v.to_erl(tab, indent+1)
          if val.lines.count  >1
            "{#{k},"+ newLine+" #{val}}"
          else
            "{#{k}, #{val}}"
          end
      }.join("," + newLine) +
        newLine +"]"
      else
        p = self.each.first
        '[{' + p[0] + ',' + p[1].to_erl(tab, indent+1) + "}]" + newLine
      end
    when Array
      '[' + self.map{|v| v.to_erl(tab, indent+1)}.join(",")  +']'
    when TrueClass then "true"
    when FalseClass then "false"
    when Integer then self.to_s
    when String then "\"#{self}\""
    when Symbol then self.to_s
    else
      raise "Don't know how to erlify #{self}"
    end
  end
end
