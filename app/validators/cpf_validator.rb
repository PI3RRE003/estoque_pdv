class CpfValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?

    # Remove qualquer caractere que não seja número
    cpf = value.to_s.gsub(/[^\d]/, "")

    unless valid_cpf?(cpf)
      record.errors.add(attribute, (options[:message] || "não é um CPF válido"))
    end
  end

  private

  def valid_cpf?(cpf)
    # Verifica se tem 11 dígitos ou se todos os números são iguais (ex: 111.111...)
    return false if cpf.length != 11 || cpf.scan(/\d/).uniq.length == 1

    # Cálculo dos dígitos verificadores
    digits = cpf.chars.map(&:to_i)

    # Valida 1º dígito
    sum = 0
    9.times { |i| sum += digits[i] * (10 - i) }
    check = (sum * 10 % 11) % 10
    return false if check != digits[9]

    # Valida 2º dígito
    sum = 0
    10.times { |i| sum += digits[i] * (11 - i) }
    check = (sum * 10 % 11) % 10
    return false if check != digits[10]

    true
  end
end
