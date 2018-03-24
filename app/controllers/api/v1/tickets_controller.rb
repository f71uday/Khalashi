
module Api
  module V1
    class TicketsController < ApplicationController
        def index
          tickets = Ticket.all
          TicketMailingMailer.ticket_mail.deliver
          render json: {status:'ok',data: tickets},status: :ok
        end

        def show
            ticket = Ticket.find(params[:id]);
        render json: {status: 'SUCCESS', message:'Loaded tickets', data:ticket },status: :ok
      end

      def create
          ticket = Ticket.new(product_params);

          kit = PDFKit.new(<<-HTML)
          <p><strong>FlickShot&nbsp;v2</strong></p>
    <p><strong>Club CodeFoster</strong></p>
    <p><strong>Shri Govindram Seksaria Institute of Technology and Science</strong></p>
    <p><strong>Indore, 452003</strong></p>
    <p><strong>Contact : 9479803953</strong></p>
    <p><a href="http://codefoster.club">http://codefoster.club</a></p>
    <hr>
    <p><strong>E-Ticket&nbsp;</strong></p>
    <p><strong>FlickShot&nbsp;Team ID :</strong></p>
    <p><strong>Booking Date:&nbsp;</strong></p>
    <p><strong>Booking ID:</strong></p>
    <table style="height: 22px;" width="571">
    <tbody>
    <tr>
    <td style="width: 277px;">Player/Team Leader Name</td>
    <td style="width: 278px;">Ticket Type</td>
    </tr>
    <tr>
    <td style="width: 277px;">&nbsp;</td>
    <td style="width: 278px;">&nbsp;</td>
    </tr>
    </tbody>
    </table>
    <p>&nbsp;</p>
    <p>&nbsp;</p>
    <p><strong>Amount Paid:&nbsp;</strong></p>
    <p><strong>No of Team Members:</strong></p>
    <p><strong>Date : 26/02/2018 11:00 AM</strong></p>
    <p><strong>Venue : Computer Center (SGSITS Indore)</strong></p>
    <p>&nbsp;</p>


    <p><strong>Important Information&nbsp;</strong></p>
    <hr>
    <p>&nbsp;</p>
    <ol>
    <li>This ticket is to be presented during the event either in digital or physical form.</li>
    <li>It is mandatory to carry Government recognised photo identification (ID) along with your E-Ticket.</li>
    <li>Carry your Payment Transaction ID with you.</li>
    </ol>
              HTML

              kit.to_file("tickets/CFCA180#{ticket.id}.pdf")


        bookinghash = Rickshaw::SHA256.hash("/home/uday/codefoster_ticket_gneration_system/tickets/CFCA180#{ticket.id}.pdf")
        qrcode = RQRCode::QRCode.new("#{ticket.name},#{ticket.booking_id},#{ticket.id}")
        svg = qrcode.as_svg(offset: 0, color: '000',
                  shape_rendering: 'crispEdges',
                  module_size: 4)
        #ticket.bookinghash = bookinghash
        ticket = ticket.attributes.merge(bookinghash: "#{bookinghash}")
        print(ticket.team_id)
        #pdf = WickedPdf.new.pdf_from_string('<h1>Hello There!</h1>');
        #render pdf: pdf
        kit = PDFKit.new(<<-HTML)
        <p><strong>FlickShot&nbsp;v2</strong></p>
  <p><strong>Club CodeFoster</strong></p>
  <p><strong>Shri Govindram Seksaria Institute of Technology and Science</strong></p>
  <p><strong>Indore, 452003</strong></p>
  <p><strong>Contact : 9479803953</strong></p>
  <p><a href="http://codefoster.club">http://codefoster.club</a></p>
  <hr>
  <p><strong>E-Ticket&nbsp;</strong></p>
  <p><strong>FlickShot&nbsp;Team ID :</strong></p>
  <p><strong>Booking Date:&nbsp;</strong></p>
  <p><strong>Booking ID:</strong></p>
  <table style="height: 22px;" width="571">
  <tbody>
  <tr>
  <td style="width: 277px;">Player/Team Leader Name</td>
  <td style="width: 278px;">Ticket Type</td>
  </tr>
  <tr>
  <td style="width: 277px;">&nbsp;</td>
  <td style="width: 278px;">&nbsp;</td>
  </tr>
  </tbody>
  </table>
  <p>&nbsp;</p>
  <p>&nbsp;</p>
  <p><strong>Amount Paid:&nbsp;</strong></p>
  <p><strong>No of Team Members:</strong></p>
  <p><strong>Date : 26/02/2018 11:00 AM</strong></p>
  <p><strong>Venue : Computer Center (SGSITS Indore)</strong></p>
  <p>&nbsp;</p>
  <img src= "#{svg.to_s}">

  <p><strong>Important Information&nbsp;</strong></p>
  <hr>
  <p>&nbsp;</p>
  <ol>
  <li>This ticket is to be presented during the event either in digital or physical form.</li>
  <li>It is mandatory to carry Government recognised photo identification (ID) along with your E-Ticket.</li>
  <li>Carry your Payment Transaction ID with you.</li>
  </ol>
            HTML

            kit.to_file("tickets/CFCA180#{ticket.id}.pdf")

          if ticket.save
          render json: {status: 'SUCCESS', message:'Added Ticket', data:ticket },status: :ok
        else
          render json: {status: 'ERROR'},status: :unprocessable_entity
        end
      end

      def product_params
          params.permit(:booking_id,:team_id,:members,:amt_paid,:name)
      end

    end
  end
end
