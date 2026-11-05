
import { Router } from "express";
import { ProductController } from "../controllers/productController.js";

export function createCategoryRoutes(
    productController: ProductController
) {
    const router = Router();

    router.get("/", productController.getCategories);

    router.get(
        "/:category/products",
        productController.getProductsByCategory
    );

    return router;
}
