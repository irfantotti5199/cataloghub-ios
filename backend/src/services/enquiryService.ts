
import type { Enquiry } from "../models/Enquiry.js";
import { EmailProvider } from "../providers/emailProvider.js";

export class EnquiryService {

    private emailProvider: EmailProvider;

    constructor(emailProvider: EmailProvider) {
        this.emailProvider = emailProvider;
    }

    async submitEnquiry(enquiry: Enquiry): Promise<void> {
        await this.emailProvider.sendEnquiryEmail(enquiry);
    }
}
