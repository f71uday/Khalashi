class TicketMailingMailer < ApplicationMailer
  def ticket_mail
    mail(to: "f71uday@gmail.com",subject: "FlickShot Event Ticket")
  end
end
