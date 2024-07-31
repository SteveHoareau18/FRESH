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

        // Création des tables (inchangé)
        // ... (le code pour CREATE TABLE reste le même)

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
