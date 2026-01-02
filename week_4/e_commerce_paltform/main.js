const readline = require('readline');
const fs = require('fs');

// Setup Readline interface for user input
const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
});

// Helper function to prompt user (Promise-based)
function ask(question) {
    return new Promise(resolve => rl.question(question, resolve));
}

// Global Data Elements
let cart = [];
let grandTotal = 0;
let discountedTotal = 0;
let totalWithTax = 0;
let finalAmount = 0;
let userEmail = "";

// --- Lab 7: Saving & Retrieving Cart Data ---
// Description: Persistent Cart with LocalStorage (Simulated with JSON file in Node.js)
const DATA_FILE = 'cart_data.json';

function saveToLocal(invoiceData) {
    const data = {
        cart: cart,
        grandTotal: grandTotal,
        email: userEmail,
        invoiceData: invoiceData,
        timestamp: new Date().toISOString()
    };
    // In a browser, this would be: localStorage.setItem('karazonData', JSON.stringify(data));
    fs.writeFileSync(DATA_FILE, JSON.stringify(data, null, 2));
    console.log("Data saved locally.");
}

function loadFromLocal() {
    // In a browser: const data = localStorage.getItem('karazonData');
    if (fs.existsSync(DATA_FILE)) {
        const rawData = fs.readFileSync(DATA_FILE);
        return JSON.parse(rawData);
    }
    return null;
}

// --- Lab 9: Error Handling & Custom Exceptions ---
class ValidationError extends Error {
    constructor(message) {
        super(message);
        this.name = "ValidationError";
    }
}

// --- Lab 12: Promises for Inventory Lookup ---
// Mock Inventory Data
const inventory = {
    "ITEM01": 10,
    "ITEM02": 5,
    "ITEM03": 0 // Out of stock
};

function checkInventory(itemCode, quantity) {
    return new Promise((resolve, reject) => {
        console.log(`Checking inventory for ${itemCode}...`);
        setTimeout(() => {
            const stock = inventory[itemCode] !== undefined ? inventory[itemCode] : 100; // Default 100 if unknown
            if (stock >= quantity) {
                resolve(true);
            } else {
                reject(new Error(`Insufficient stock for item ${itemCode}. Available: ${stock}`));
            }
        }, 500); // Simulate delay
    });
}

// --- Lab 1: Add Items to Cart ---
async function addItemToCart() {
    while (true) {
        try {
            console.log("\n--- Add Item to Cart ---");
            const itemCode = await ask("Enter Item Code: ");
            const description = await ask("Enter Description: ");
            
            let quantityInput = await ask("Enter Quantity: ");
            let quantity = Number(quantityInput);
            
            let priceInput = await ask("Enter Price Per Unit: ");
            let pricePerUnit = Number(priceInput);

            // Lab 9: Validation
            if (isNaN(quantity) || quantity <= 0) throw new ValidationError("Quantity must be a positive number.");
            if (isNaN(pricePerUnit) || pricePerUnit <= 0) throw new ValidationError("Price must be a positive number.");

            // Lab 12: Inventory Check
            await checkInventory(itemCode, quantity);

            const totalPrice = quantity * pricePerUnit;
            
            const item = {
                itemCode,
                description,
                quantity,
                pricePerUnit,
                totalPrice
            };

            cart.push(item);
            console.log(`Item added! Total: $${totalPrice}`);

            const more = await ask("Add another item? (yes/no): ");
            if (more.toLowerCase() !== 'yes') break;

        } catch (error) {
            console.error(`Error: ${error.message}`);
        }
    }

    // Calculate Grand Total
    grandTotal = cart.reduce((sum, item) => sum + item.totalPrice, 0);
    console.log("\n--- Cart Summary ---");
    console.table(cart);
    console.log(`Grand Total: $${grandTotal}`);
}

// --- Lab 10: Closures for Membership Offers ---
function getDiscountFunction(type) {
    let rate = 0;
    if (type.toLowerCase() === 'silver') rate = 0.05;
    else if (type.toLowerCase() === 'gold') rate = 0.10;
    else if (type.toLowerCase() === 'platinum') rate = 0.15;
    
    // Closure capturing 'rate'
    return function(amount) {
        return amount * rate;
    };
}

// --- Lab 2: Apply Membership Discount ---
async function applyMembershipDiscount() {
    console.log("\n--- Membership Discount ---");
    const isMember = await ask("Are you a member? (yes/no): ");
    
    if (isMember.toLowerCase() === 'yes') {
        const type = await ask("Enter Membership Type (Silver/Gold/Platinum): ");
        
        // Lab 10 usage
        const calculateDiscount = getDiscountFunction(type);
        const discountAmount = calculateDiscount(grandTotal);
        
        discountedTotal = grandTotal - discountAmount;
        console.log(`Discount Applied: $${discountAmount} (${type})`);
    } else {
        discountedTotal = grandTotal;
        console.log("No discount applied.");
    }
    console.log(`Discounted Total: $${discountedTotal}`);
}

// --- Lab 3: Add GST and Platform Fee ---
function applyTaxAndFees() {
    console.log("\n--- Tax and Fees ---");
    const gstRate = 0.18;
    const platformFeeRate = 0.002;

    const gstAmount = discountedTotal * gstRate;
    const platformFee = discountedTotal * platformFeeRate;

    totalWithTax = discountedTotal + gstAmount + platformFee;

    console.log(`GST (18%): $${gstAmount.toFixed(2)}`);
    console.log(`Platform Fee (0.2%): $${platformFee.toFixed(2)}`);
    console.log(`Total with Tax: $${totalWithTax.toFixed(2)}`);
}

// --- Lab 11: Asynchronous Payment Confirmation ---
async function processPaymentAsync(mode) {
    console.log(`Processing ${mode} payment...`);
    return new Promise((resolve) => {
        setTimeout(() => {
            resolve("Success");
        }, 2000); // 2 seconds delay
    });
}

// --- Lab 4: Apply Payment Mode Charges ---
async function applyPaymentCharges() {
    console.log("\n--- Payment ---");
    let paymentMode = "";
    while (true) {
        try {
            paymentMode = await ask("Enter Payment Mode (Card/UPI/Cash): ");
            if (!["card", "upi", "cash"].includes(paymentMode.toLowerCase())) {
                throw new ValidationError("Invalid payment mode. Please enter Card, UPI, or Cash.");
            }
            break;
        } catch (error) {
            console.error(error.message);
        }
    }
    
    let surcharge = 0;
    let convenienceFee = 0;

    if (paymentMode.toLowerCase() === 'card' && totalWithTax < 1000) {
        surcharge = totalWithTax * 0.025;
        console.log(`Surcharge (2.5%): $${surcharge.toFixed(2)}`);
    } else {
        convenienceFee = totalWithTax * 0.01;
        console.log(`Convenience Fee (1%): $${convenienceFee.toFixed(2)}`);
    }

    finalAmount = totalWithTax + surcharge + convenienceFee;
    console.log(`Final Payable Amount: $${finalAmount.toFixed(2)}`);

    // Lab 11: Async Payment
    await processPaymentAsync(paymentMode);
    console.log("Payment Successful!");
    
    return paymentMode;
}

// --- Lab 5: Generate Final Invoice ---
function generateInvoice(paymentMode) {
    console.log("\n==========================================");
    console.log("             KARAZON INVOICE              ");
    console.log("==========================================");
    const invoiceDate = new Date();
    const invoiceNumber = "INV-" + Math.floor(Math.random() * 100000);
    
    console.log(`Invoice No: ${invoiceNumber}`);
    console.log(`Date: ${invoiceDate.toLocaleString()}`);
    console.log("------------------------------------------");
    console.log("Items:");
    cart.forEach(item => {
        console.log(`${item.itemCode} - ${item.description} (x${item.quantity}) : $${item.totalPrice}`);
    });
    console.log("------------------------------------------");
    console.log(`Subtotal:          $${grandTotal.toFixed(2)}`);
    console.log(`Discounted Total:  $${discountedTotal.toFixed(2)}`);
    console.log(`Tax & Fees:        $${(totalWithTax - discountedTotal).toFixed(2)}`);
    console.log(`Final Amount:      $${finalAmount.toFixed(2)}`);
    console.log(`Payment Mode:      ${paymentMode}`);
    console.log("==========================================");
    
    return { invoiceNumber, invoiceDate, finalAmount };
}

// --- Lab 8: Email Validation & Notification ---
function validateEmail(email) {
    const regex = /^[a-zA-Z0-9._%+-]+@karunya\.edu$/;
    return regex.test(email);
}

// --- Lab 6: Bonus – Email Simulation and Local Save ---
async function sendEmailAndSave(invoiceData) {
    console.log("\n--- Email Confirmation ---");
    while (true) {
        try {
            userEmail = await ask("Enter Email for confirmation (@karunya.edu): ");
            
            // Lab 8 Validation
            if (!validateEmail(userEmail)) {
                throw new ValidationError("Invalid email domain. Must be @karunya.edu");
            }
            break;
        } catch (e) {
            console.error(e.message);
        }
    }

    console.log(`Sending invoice to ${userEmail}...`);
    console.log("Email sent successfully!");

    // Lab 6: JSON Output
    const invoiceJSON = JSON.stringify({ ...invoiceData, cart, email: userEmail });
    // console.log("Invoice JSON:", invoiceJSON); // Optional display

    // Lab 7: Save
    saveToLocal(invoiceData);
}

// --- Lab 13: Callback Function for Billing Completion ---
function completeBilling(callback) {
    console.log("\nFinalizing transaction...");
    callback();
}

// --- Main Execution Flow ---
async function main() {
    console.log("Welcome to Karazon.com Beta!");

    // Lab 7: Check for existing data
    const savedData = loadFromLocal();
    if (savedData) {
        const resume = await ask("Found saved cart. Resume? (yes/no): ");
        if (resume.toLowerCase() === 'yes') {
            cart = savedData.cart;
            grandTotal = savedData.grandTotal;
            userEmail = savedData.email;
            console.log("Cart restored.");
        } else {
            cart = [];
        }
    }

    if (cart.length === 0) {
        await addItemToCart();
    } else {
        // If resumed, maybe ask to add more?
        const addMore = await ask("Add more items? (yes/no): ");
        if (addMore.toLowerCase() === 'yes') {
            await addItemToCart();
        }
    }

    if (cart.length > 0) {
        await applyMembershipDiscount();
        applyTaxAndFees();
        const paymentMode = await applyPaymentCharges();
        
        const invoiceData = generateInvoice(paymentMode);
        
        await sendEmailAndSave(invoiceData);

        // Lab 13 Callback
        completeBilling(() => {
            console.log("\nThank you for shopping with Karazon!");
            rl.close();
        });
    } else {
        console.log("Cart is empty. Exiting.");
        rl.close();
    }
}

// Start the program
main();
