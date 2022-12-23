lines = File.read('24.input').split("\n")

# problem 1

def func1(z, input, var1, var2)
  if (z % 26) == input - var1
    [z, false]
  else
    [z * 26 + (input + var2), true]
  end
end

def func2(z, input, var1, var2)
  if (z % 26) == input - var1
    [z / 26, true]
  else
    [(z / 26) * 26 + (input + var2), false]
  end
end

instructions = lines.map do |s|
  oper, arg1, arg2 = s.split(' ')
  if !arg2.nil?
    arg2 = %w[w x y z].include?(arg2) ? arg2 : arg2.to_i
  end
  [oper, arg1, arg2]
end

ALGARISMS_DESC = (1..9).to_a.reverse.freeze

def problem1
  ALGARISMS_DESC.each do |input1|
    z1, = func1(0, input1, 12, 7)

    ALGARISMS_DESC.each do |input2|
      z2, = func1(z1, input2, 12, 8)

      ALGARISMS_DESC.each do |input3|
        z3, = func1(z2, input3, 13, 2)

        ALGARISMS_DESC.each do |input4|
          z4, = func1(z3, input4, 12, 11)

          ALGARISMS_DESC.each do |input5|
            z5, ev = func2(z4, input5, -3, 6)
            next unless ev

            ALGARISMS_DESC.each do |input6|
              # puts [input1, input2, input3, input4, input5, input6].map(&:to_s).join
              z6, = func1(z5, input6, 10, 12)

              ALGARISMS_DESC.each do |input7|
                z7, = func1(z6, input7, 14, 14)

                ALGARISMS_DESC.each do |input8|
                  z8, ev = func2(z7, input8, -16, 13)
                  next unless ev

                  ALGARISMS_DESC.each do |input9|
                    z9, = func1(z8, input9, 12, 15)

                    ALGARISMS_DESC.each do |input10|
                      z10, ev = func2(z9, input10, -8, 10)
                      next unless ev

                      ALGARISMS_DESC.each do |input11|
                        z11, ev = func2(z10, input11, -12, 6)
                        next unless ev

                        ALGARISMS_DESC.each do |input12|
                          z12, = func2(z11, input12, -7, 10)

                          ALGARISMS_DESC.each do |input13|
                            z13, = func2(z12, input13, -6, 8)

                            ALGARISMS_DESC.each do |input14|
                              z14, = func2(z13, input14, -11, 5)

                              if z14 == 0
                                return [input1, input2, input3, input4, input5, input6, input7, input8, input9, input10, input11, input12, input13, input14].map(&:to_s).join
                              end
                            end
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end

puts problem1

# problem 2

ALGARISMS_ASC = (1..9).to_a.freeze

def problem2
  ALGARISMS_ASC.each do |input1|
    z1, = func1(0, input1, 12, 7)

    ALGARISMS_ASC.each do |input2|
      z2, = func1(z1, input2, 12, 8)

      ALGARISMS_ASC.each do |input3|
        z3, = func1(z2, input3, 13, 2)

        ALGARISMS_ASC.each do |input4|
          z4, = func1(z3, input4, 12, 11)

          ALGARISMS_ASC.each do |input5|
            z5, ev = func2(z4, input5, -3, 6)
            next unless ev

            ALGARISMS_ASC.each do |input6|
              z6, = func1(z5, input6, 10, 12)

              ALGARISMS_ASC.each do |input7|
                z7, = func1(z6, input7, 14, 14)

                ALGARISMS_ASC.each do |input8|
                  z8, ev = func2(z7, input8, -16, 13)
                  next unless ev

                  ALGARISMS_ASC.each do |input9|
                    z9, = func1(z8, input9, 12, 15)

                    ALGARISMS_ASC.each do |input10|
                      z10, ev = func2(z9, input10, -8, 10)
                      next unless ev

                      ALGARISMS_ASC.each do |input11|
                        z11, ev = func2(z10, input11, -12, 6)
                        next unless ev

                        ALGARISMS_ASC.each do |input12|
                          z12, = func2(z11, input12, -7, 10)

                          ALGARISMS_ASC.each do |input13|
                            z13, = func2(z12, input13, -6, 8)

                            ALGARISMS_ASC.each do |input14|
                              z14, = func2(z13, input14, -11, 5)

                              if z14 == 0
                                return [input1, input2, input3, input4, input5, input6, input7, input8, input9, input10, input11, input12, input13, input14].map(&:to_s).join
                              end
                            end
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end

puts problem2
