
import { Router } from "express";
import { EnquiryController } from "../controllers/enquiryController.js";

export function createEnquiryRoutes(
    enquiryController: EnquiryController
) {
    const router = Router();

    router.post("/", enquiryController.submitEnquiry);

    return router;
}
