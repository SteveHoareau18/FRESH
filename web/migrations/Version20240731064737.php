<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Auto-generated Migration: Please modify to your needs!
 */
final class Version20240731064737 extends AbstractMigration
{
    public function getDescription(): string
    {
        return '';
    }

    public function up(Schema $schema): void
    {
        $this->addSql('SET FOREIGN_KEY_CHECKS=0');

        $this->addSql('CREATE TABLE IF NOT EXISTS alert (id INT AUTO_INCREMENT NOT NULL, food_id INT NOT NULL, refrigerator_id INT NOT NULL, recipient_id INT NOT NULL, message VARCHAR(255) NOT NULL, alerted_date DATETIME NOT NULL, INDEX IDX_17FD46C1BA8E87C4 (food_id), INDEX IDX_17FD46C1915EAEB (refrigerator_id), INDEX IDX_17FD46C1E92F8F78 (recipient_id), PRIMARY KEY(id)) DEFAULT CHARACTER SET utf8mb4 COLLATE `utf8mb4_unicode_ci` ENGINE = InnoDB');
        $this->addSql('CREATE TABLE IF NOT EXISTS email_token (id INT AUTO_INCREMENT NOT NULL, fresh_user_id INT NOT NULL, send_date DATETIME NOT NULL, expire_date DATETIME NOT NULL, token VARCHAR(255) NOT NULL, UNIQUE INDEX UNIQ_C27AE0B45F37A13B (token), INDEX IDX_C27AE0B445196B6 (fresh_user_id), PRIMARY KEY(id)) DEFAULT CHARACTER SET utf8mb4 COLLATE `utf8mb4_unicode_ci` ENGINE = InnoDB');
        $this->addSql('CREATE TABLE IF NOT EXISTS food (id INT AUTO_INCREMENT NOT NULL, refrigerator_id INT NOT NULL, name VARCHAR(255) NOT NULL, quantity INT NOT NULL, adding_date DATETIME DEFAULT NULL, expire_date DATETIME NOT NULL, INDEX IDX_D43829F7915EAEB (refrigerator_id), PRIMARY KEY(id)) DEFAULT CHARACTER SET utf8mb4 COLLATE `utf8mb4_unicode_ci` ENGINE = InnoDB');
        $this->addSql('CREATE TABLE IF NOT EXISTS food_recipe_in_refrigerator (id INT AUTO_INCREMENT NOT NULL, refrigerator_id INT NOT NULL, food_id INT NOT NULL, recipe_id INT NOT NULL, quantity INT NOT NULL, unit VARCHAR(20) DEFAULT NULL, INDEX IDX_22D2F3CD915EAEB (refrigerator_id), INDEX IDX_22D2F3CDBA8E87C4 (food_id), INDEX IDX_22D2F3CD59D8A214 (recipe_id), PRIMARY KEY(id)) DEFAULT CHARACTER SET utf8mb4 COLLATE `utf8mb4_unicode_ci` ENGINE = InnoDB');
        $this->addSql('CREATE TABLE IF NOT EXISTS food_recipe_not_in_refrigerator (id INT AUTO_INCREMENT NOT NULL, recipe_id INT DEFAULT NULL, name VARCHAR(255) NOT NULL, quantity INT NOT NULL, unit VARCHAR(20) DEFAULT NULL, can_be_regroup TINYINT(1) DEFAULT NULL, INDEX IDX_B0D4BE2259D8A214 (recipe_id), PRIMARY KEY(id)) DEFAULT CHARACTER SET utf8mb4 COLLATE `utf8mb4_unicode_ci` ENGINE = InnoDB');
        $this->addSql('CREATE TABLE IF NOT EXISTS fresh_user (id INT AUTO_INCREMENT NOT NULL, email VARCHAR(180) NOT NULL, roles JSON NOT NULL, password VARCHAR(255) NOT NULL, is_verified TINYINT(1) NOT NULL, firstname VARCHAR(255) NOT NULL, name VARCHAR(255) NOT NULL, register_date DATETIME DEFAULT NULL, last_connection DATETIME DEFAULT NULL, UNIQUE INDEX UNIQ_569E4F03E7927C74 (email), PRIMARY KEY(id)) DEFAULT CHARACTER SET utf8mb4 COLLATE `utf8mb4_unicode_ci` ENGINE = InnoDB');
        $this->addSql('CREATE TABLE IF NOT EXISTS recipe (id INT AUTO_INCREMENT NOT NULL, owner_id INT NOT NULL, name VARCHAR(255) NOT NULL, create_date DATETIME NOT NULL, last_cooking_date DATETIME DEFAULT NULL, INDEX IDX_DA88B1377E3C61F9 (owner_id), PRIMARY KEY(id)) DEFAULT CHARACTER SET utf8mb4 COLLATE `utf8mb4_unicode_ci` ENGINE = InnoDB');
        $this->addSql('CREATE TABLE IF NOT EXISTS refrigerator (id INT AUTO_INCREMENT NOT NULL, owner_id INT NOT NULL, name VARCHAR(255) NOT NULL, adding_date DATETIME DEFAULT NULL, INDEX IDX_4619AF357E3C61F9 (owner_id), PRIMARY KEY(id)) DEFAULT CHARACTER SET utf8mb4 COLLATE `utf8mb4_unicode_ci` ENGINE = InnoDB');
        $this->addSql('CREATE TABLE IF NOT EXISTS messenger_messages (id BIGINT AUTO_INCREMENT NOT NULL, body LONGTEXT NOT NULL, headers LONGTEXT NOT NULL, queue_name VARCHAR(190) NOT NULL, created_at DATETIME NOT NULL COMMENT \'(DC2Type:datetime_immutable)\', available_at DATETIME NOT NULL COMMENT \'(DC2Type:datetime_immutable)\', delivered_at DATETIME DEFAULT NULL COMMENT \'(DC2Type:datetime_immutable)\', INDEX IDX_75EA56E0FB7336F0 (queue_name), INDEX IDX_75EA56E0E3BD61CE (available_at), INDEX IDX_75EA56E016BA31DB (delivered_at), PRIMARY KEY(id)) DEFAULT CHARACTER SET utf8mb4 COLLATE `utf8mb4_unicode_ci` ENGINE = InnoDB');

        // Fonction pour vérifier et supprimer une clé étrangère si elle existe
        $checkAndDropForeignKey = function(string $table, string $constraint) {
            return "
            SET @constraint_name = (
                SELECT CONSTRAINT_NAME 
                FROM information_schema.TABLE_CONSTRAINTS 
                WHERE TABLE_SCHEMA = DATABASE()
                AND TABLE_NAME = '$table' 
                AND CONSTRAINT_NAME = '$constraint'
                AND CONSTRAINT_TYPE = 'FOREIGN KEY'
            );
            SET @sql = IF(@constraint_name IS NOT NULL, 
                CONCAT('ALTER TABLE `$table` DROP FOREIGN KEY `', @constraint_name, '`'), 
                'SELECT 1');
            PREPARE stmt FROM @sql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
        ";
        };

        // Vérification et suppression des contraintes de clé étrangère
        $this->addSql($checkAndDropForeignKey('alert', 'FK_17FD46C1BA8E87C4'));
        $this->addSql($checkAndDropForeignKey('alert', 'FK_17FD46C1915EAEB'));
        $this->addSql($checkAndDropForeignKey('alert', 'FK_17FD46C1E92F8F78'));
        $this->addSql($checkAndDropForeignKey('email_token', 'FK_C27AE0B445196B6'));
        $this->addSql($checkAndDropForeignKey('food', 'FK_D43829F7915EAEB'));
        $this->addSql($checkAndDropForeignKey('food_recipe_in_refrigerator', 'FK_22D2F3CD915EAEB'));
        $this->addSql($checkAndDropForeignKey('food_recipe_in_refrigerator', 'FK_22D2F3CDBA8E87C4'));
        $this->addSql($checkAndDropForeignKey('food_recipe_in_refrigerator', 'FK_22D2F3CD59D8A214'));
        $this->addSql($checkAndDropForeignKey('food_recipe_not_in_refrigerator', 'FK_B0D4BE2259D8A214'));
        $this->addSql($checkAndDropForeignKey('recipe', 'FK_DA88B1377E3C61F9'));
        $this->addSql($checkAndDropForeignKey('refrigerator', 'FK_4619AF357E3C61F9'));

        // Ajout des contraintes de clé étrangère
        $this->addSql('ALTER TABLE alert ADD CONSTRAINT FK_17FD46C1BA8E87C4 FOREIGN KEY (food_id) REFERENCES food (id)');
        $this->addSql('ALTER TABLE alert ADD CONSTRAINT FK_17FD46C1915EAEB FOREIGN KEY (refrigerator_id) REFERENCES refrigerator (id)');
        $this->addSql('ALTER TABLE alert ADD CONSTRAINT FK_17FD46C1E92F8F78 FOREIGN KEY (recipient_id) REFERENCES fresh_user (id)');
        $this->addSql('ALTER TABLE email_token ADD CONSTRAINT FK_C27AE0B445196B6 FOREIGN KEY (fresh_user_id) REFERENCES fresh_user (id)');
        $this->addSql('ALTER TABLE food ADD CONSTRAINT FK_D43829F7915EAEB FOREIGN KEY (refrigerator_id) REFERENCES refrigerator (id)');
        $this->addSql('ALTER TABLE food_recipe_in_refrigerator ADD CONSTRAINT FK_22D2F3CD915EAEB FOREIGN KEY (refrigerator_id) REFERENCES refrigerator (id)');
        $this->addSql('ALTER TABLE food_recipe_in_refrigerator ADD CONSTRAINT FK_22D2F3CDBA8E87C4 FOREIGN KEY (food_id) REFERENCES food (id)');
        $this->addSql('ALTER TABLE food_recipe_in_refrigerator ADD CONSTRAINT FK_22D2F3CD59D8A214 FOREIGN KEY (recipe_id) REFERENCES recipe (id)');
        $this->addSql('ALTER TABLE food_recipe_not_in_refrigerator ADD CONSTRAINT FK_B0D4BE2259D8A214 FOREIGN KEY (recipe_id) REFERENCES recipe (id)');
        $this->addSql('ALTER TABLE recipe ADD CONSTRAINT FK_DA88B1377E3C61F9 FOREIGN KEY (owner_id) REFERENCES fresh_user (id)');
        $this->addSql('ALTER TABLE refrigerator ADD CONSTRAINT FK_4619AF357E3C61F9 FOREIGN KEY (owner_id) REFERENCES fresh_user (id)');

        // Réactiver la vérification des clés étrangères
        $this->addSql('SET FOREIGN_KEY_CHECKS=1');
    }

    public function down(Schema $schema): void
    {
    }
}
