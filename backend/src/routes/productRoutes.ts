
import { Router } from "express";
import { ProductController } from "../controllers/productController.js";

export function createProductRoutes(
    productController: ProductController
) {
    const router = Router();

router.get("/search", productController.searchProducts);
router.get("/featured", productController.getFeaturedProducts);
router.get("/:id", productController.getProductById);
router.get("/", productController.getProducts);

    return router;
}
