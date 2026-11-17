
import nodemailer from "nodemailer";
import type { Enquiry } from "../models/Enquiry.js";

export class EmailProvider {

async verifyConnection(): Promise<void> {
    await this.transporter.verify();
}

    private transporter = nodemailer.createTransport({
        host: process.env.SMTP_HOST,
        port: Number(process.env.SMTP_PORT),
        secure: process.env.SMTP_SECURE === "true",
        auth: {
            user: process.env.SMTP_USER,
            pass: process.env.SMTP_PASSWORD
        }
    });

    async sendEnquiryEmail(enquiry: Enquiry): Promise<void> {
        await this.transporter.sendMail({
            from: process.env.SMTP_USER,
            to: process.env.SALES_EMAIL,
            subject: "New Product Enquiry",
            text: `
Name: ${enquiry.name}
Email: ${enquiry.email}
Phone: ${enquiry.phone}
Message: ${enquiry.message}
            `
        });
    }
}
