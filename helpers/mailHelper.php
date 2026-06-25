<?php
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

// --- CAMBIO 1: Usa el autoloader de Composer ---
// Esto carga automáticamente PHPMailer y sus dependencias.
// Ya no necesitas los otros 'require_once'.
require_once __DIR__ . '/../vendor/autoload.php';

class MailHelper
{
    private $mailer;

    public function __construct()
    {
        $this->mailer = new PHPMailer(true);

        // Configuración del servidor SMTP desde variables de entorno
        $this->mailer->isSMTP();
        $this->mailer->Host = $_ENV['MAIL_HOST'] ?? 'localhost';
        $this->mailer->SMTPAuth = true;
        $this->mailer->Username = $_ENV['MAIL_USERNAME'] ?? '';
        $this->mailer->Password = $_ENV['MAIL_PASSWORD'] ?? '';

        // --- CAMBIO 2: Cifrado SSL (SMTPS) ---
        // Tu PDF indica SSL/TLS en el puerto 465. 
        // En PHPMailer, esto es 'ENCRYPTION_SMTPS'.
        $this->mailer->SMTPSecure = PHPMailer::ENCRYPTION_SMTPS;

        // --- CAMBIO 3: Puerto 465 ---
        // El puerto por defecto ahora es 465, coincidiendo con tu PDF.
        $this->mailer->Port = $_ENV['MAIL_PORT'] ?? 465;

        // --- CAMBIO 4: Depuración (Desactivada para producción) ---
        // Ponlo en 2 si necesitas depurar, pero 0 es mejor para producción.
        $this->mailer->SMTPDebug = 0; 
    
        $this->mailer->Timeout = 10; 
        
        $fromName = $_ENV['MAIL_FROM_NAME'] ?? 'SISSUP Soporte';

        $this->mailer->setFrom($_ENV['MAIL_FROM'] ?? 'noreply@example.com', $fromName);
    }

    public function sendMail($to, $subject, $body, $isHTML = true)
    {
        try {
            $this->mailer->clearAddresses();
            $this->mailer->clearAttachments();

            // Destinatario y contenido
            $this->mailer->addAddress($to);
            $this->mailer->isHTML($isHTML);
            $this->mailer->Subject = $subject;
            $this->mailer->Body = $body;
            // Opcional: Añadir un cuerpo de texto plano para clientes sin HTML
            // $this->mailer->AltBody = strip_tags($body); 

            $this->mailer->send();
            $this->mailer->smtpClose();

            return true;
        } catch (Exception $e) {
            // Guarda el error en el log de PHP en lugar de mostrarlo
            error_log("Mailer Error: " . $this->mailer->ErrorInfo);
            return false;
        }
    }
}