namespace :db do
  desc "Faz backup do banco de dados SQLite"
  task backup: :environment do
    # Define o nome do ficheiro com data e hora
    datestamp = Time.now.strftime("%Y%m%d_%H%M%S")
    backup_file = "backups/db_backup_#{datestamp}.sqlite3"

    # Caminho do banco de dados atual (geralmente db/development.sqlite3)
    source_file = Rails.root.join("db", "development.sqlite3")

    if File.exist?(source_file)
      FileUtils.cp(source_file, backup_file)
      puts "✅ Backup realizado com sucesso: #{backup_file}"

      # Opcional: Remove backups com mais de 7 dias para não encher o disco
      Dir.glob("backups/db_backup_*.sqlite3").each do |f|
        if File.mtime(f) < 7.days.ago
          File.delete(f)
          puts "🗑️ Backup antigo removido: #{f}"
        end
      end
    else
      puts "❌ Erro: Banco de dados não encontrado em #{source_file}"
    end
  end
end
