
import express from "express";

import { FakeStoreProvider } from "./providers/fakeStoreProvider.js";
import { ProductService } from "./services/productService.js";
import { ProductController } from "./controllers/productController.js";
import { createProductRoutes } from "./routes/productRoutes.js";
import { createCategoryRoutes } from "./routes/categoryRoutes.js";
import "dotenv/config";
import { EmailProvider } from "./providers/emailProvider.js";
import { EnquiryService } from "./services/enquiryService.js";
import { EnquiryController } from "./controllers/enquiryController.js";
import { createEnquiryRoutes } from "./routes/enquiryRoutes.js";


const app = express();

app.use(express.json());

// 1. Create the provider
const fakeStoreProvider = new FakeStoreProvider();

// 2. Inject provider into service
const productService = new ProductService(fakeStoreProvider);

// 3. Inject service into controller
const productController = new ProductController(productService);

// 4. Create product routes
const productRoutes = createProductRoutes(productController);
const categoryRoutes = createCategoryRoutes(productController);


// 5. Register routes with Express
app.use("/api/products", productRoutes);
app.use("/api/categories", categoryRoutes);


// ENQUIRY DEPENDENCIES
const emailProvider = new EmailProvider();
const enquiryService = new EnquiryService(emailProvider);
const enquiryController = new EnquiryController(enquiryService);
const enquiryRoutes = createEnquiryRoutes(enquiryController);

app.use("/api/enquiries", enquiryRoutes);



app.get("/api/health", (_req, res) => {
    res.status(200).json({
        status: "success",
        message: "CatalogHub API is running"
    });
});

const PORT = 3000;

app.listen(PORT, () => {
    console.log(`CatalogHub API running on port ${PORT}`);
});
