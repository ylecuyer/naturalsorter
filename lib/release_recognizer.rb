class ReleaseRecognizer

  def self.scoped? value 
    self.alpha?(value) or self.beta?(value) or 
    self.dev?(value) or self.rc?(value) or 
    self.snapshot?(value) or self.pre?(value) or 
    self.jbossorg?(value)
  end

  def self.remove_scope value 
    if self.alpha? value
      new_value = value.gsub(/\.\w*alpha.*$/i, "")
      return new_value.gsub(/\.\w*a.*$/i, "")
    elsif self.beta? value
      new_value = value.gsub(/\.\w*beta.*$/i, "")
      return new_value.gsub(/\.\w*b.*$/i, "")
    elsif self.rc? value
      return value.gsub(/\.\w*rc.*$/i, "")
    elsif self.pre? value
      return value.gsub(/\.\w*pre.*$/i, "")
    elsif self.jbossorg? value
      return value.gsub(/\.jbossorg.*$/i, "")
    elsif self.snapshot? value
      return value.gsub(/\.snapshot.*$/i, "")
    end
    return value
  end

  def self.release? value
    self.stable? value 
  end

  def self.stable? value
    if value.match(/.+RELEASE.*/i) or value.match(/.+BUILD.*/i) or 
      value.match(/.+FINAL.*/i) or value.match(/.+SP.*/i) or
      value.match(/.+GA.*/i) 
      return true 
    end
    !self.alpha?(value) and !self.beta?(value) and 
    !self.dev?(value) and !self.pre?(value) and
    !self.rc?(value) and !value.match(/.+SEC.*/i) and 
    !self.snapshot?(value) and !value.match(/.+M.+/i)
  end

  def self.alpha? value 
    value.match(/.*alpha.*/i) or value.match(/.+a.*/i)
  end

  def self.beta? value 
    value.match(/.*beta.*/i) or value.match(/.+b.*/i)
  end

  def self.dev? value 
    value.match(/.*dev.*/i)
  end

  def self.rc? value 
    value.match(/.*rc.*/i) 
  end

  def self.snapshot? value 
    value.match(/.+SNAPSHOT.*/i)
  end

  def self.pre? value 
    value.match(/.*pre.*$/i)
  end

  def self.jbossorg? value 
    value.match(/.*jbossorg.*$/i)
  end

end
