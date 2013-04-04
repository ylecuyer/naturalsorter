class VersionTagRecognizer

  A_STABILITY_STABLE = "stable"
  A_STABILITY_PRE = "pre"
  A_STABILITY_RC = "RC"
  A_STABILITY_BETA = "beta"
  A_STABILITY_ALPHA = "alpha"
  A_STABILITY_SNAPSHOT = "SNAPSHOT"
  A_STABILITY_DEV = "dev"

  def self.value_for( value )
    return 0  if self.dev? value
    return 2  if self.snapshot? value
    return 3  if self.alpha? value
    return 4  if self.beta? value
    return 5  if self.rc? value
    return 6  if self.pre? value
    return 10 if self.stable? value
    return 1
  end

  def self.compare_tags( a, b)
    a_val = self.value_for a 
    b_val = self.value_for b
    return -1 if a_val < b_val
    return  1 if a_val > b_val
    return 0
  end

  def self.tagged? value 
    self.alpha?(value) or self.beta?(value) or 
    self.dev?(value) or self.rc?(value) or 
    self.snapshot?(value) or self.pre?(value) or 
    self.jbossorg?(value)
  end

  def self.remove_tag value 
    if self.alpha? value
      new_value = value.gsub(/\.[\w-]*alpha.*$/i, "")
      return new_value.gsub(/\.[\w-]*a.*$/i, "")
    elsif self.beta? value
      new_value = value.gsub(/\.[\w-]*beta.*$/i, "")
      return new_value.gsub(/\.[\w-]*b.*$/i, "")
    elsif self.rc? value
      return value.gsub(/\.[\w-]*rc.*$/i, "")
    elsif self.pre? value
      return value.gsub(/\.[\w-]*pre.*$/i, "")
    elsif self.jbossorg? value
      return value.gsub(/\.jbossorg.*$/i, "")
    elsif self.snapshot? value
      return value.gsub(/\.snapshot.*$/i, "")
    end
    return value
  end

  def self.remove_minimum_stability val 
    if val.match(/@.*$/)
      val.gsub!(/@.*$/, "")  
    end
  end

  def self.does_it_fit_stability?( version_number, stability )
    if stability.casecmp( A_STABILITY_STABLE ) == 0
      if self.stable?( version_number )
        return true 
      end
    elsif stability.casecmp( A_STABILITY_PRE ) == 0
      if self.stable?( version_number ) || 
         self.pre?( version_number )
        return true 
      end
    elsif stability.casecmp( A_STABILITY_RC ) == 0
      if self.stable?( version_number ) || 
         self.rc?( version_number )
        return true 
      end
    elsif stability.casecmp( A_STABILITY_BETA ) == 0
      if self.stable?( version_number ) || 
         self.rc?( version_number ) ||
         self.beta?( version_number )
        return true 
      end
    elsif stability.casecmp( A_STABILITY_ALPHA ) == 0 
      if self.stable?( version_number ) || 
         self.rc?( version_number ) ||
         self.beta?( version_number ) || 
         self.alpha?( version_number )
        return true 
      end
    elsif stability.casecmp( A_STABILITY_SNAPSHOT ) == 0 
      if self.stable?( version_number ) || 
         self.rc?( version_number ) ||
         self.pre?( version_number ) ||
         self.beta?( version_number ) || 
         self.alpha?( version_number ) || 
         self.snapshot?( version_number ) 
        return true 
      end
    elsif stability.casecmp( A_STABILITY_DEV ) == 0 
      return true 
    else  
      return false 
    end
  end

  def self.stability_tag_for( version )
    if version.match(/@.*$/)
      spliti = version.split("@")
      return spliti[1]
    else 
      if self.stable? version
        return A_STABILITY_STABLE
      elsif self.pre? version
        return A_STABILITY_PRE
      elsif self.rc? version
        return A_STABILITY_RC
      elsif self.beta? version
        return A_STABILITY_BETA
      elsif self.alpha? version
        return A_STABILITY_ALPHA
      elsif self.snapshot? version
        return A_STABILITY_SNAPSHOT
      else
        return A_STABILITY_DEV
      end
    end 
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
    return false if self.beta? value
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