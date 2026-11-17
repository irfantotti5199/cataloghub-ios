
import type { Request, Response } from "express";
import type { Enquiry } from "../models/Enquiry.js";
import { EnquiryService } from "../services/enquiryService.js";

export class EnquiryController {

    private enquiryService: EnquiryService;

    constructor(enquiryService: EnquiryService) {
        this.enquiryService = enquiryService;
    }

    submitEnquiry = async (req: Request, res: Response) => {
        try {

            // 1. Extract enquiry details from request body
            const { name, email, phone, message } = req.body;

            // 2. Validate required fields
            if (
                typeof name !== "string" ||
                typeof email !== "string" ||
                typeof phone !== "string" ||
                typeof message !== "string" ||
                !name.trim() ||
                !email.trim() ||
                !phone.trim() ||
                !message.trim()
            ) {
                res.status(400).json({
                    status: "error",
                    message: "All enquiry fields are required"
                });
                return;
            }

            // 3. Validate email
            const normalizedEmail = email.trim().toLowerCase();

            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

            if (!emailRegex.test(normalizedEmail)) {
                res.status(400).json({
                    status: "error",
                    message: "Please provide a valid email address"
                });
                return;
            }

            // 4. Validate phone number
            const normalizedPhone = phone.trim();

            if (!/^\+?[0-9]{10,15}$/.test(normalizedPhone)) {
                res.status(400).json({
                    status: "error",
                    message: "Please provide a valid phone number"
                });
                return;
            }

            // 5. Create enquiry object
            const enquiry: Enquiry = {
                name: name.trim(),
                email: normalizedEmail,
                phone: normalizedPhone,
                message: message.trim()
            };

            // 6. Submit enquiry through service
            await this.enquiryService.submitEnquiry(enquiry);

            // 7. Return success response
            res.status(200).json({
                status: "success",
                message: "Enquiry submitted successfully"
            });

        } catch (error) {

            // 8. Handle unexpected errors
            console.error("Error submitting enquiry:", error);

            res.status(500).json({
                status: "error",
                message: "Unable to submit enquiry"
            });
        }
    };
}
