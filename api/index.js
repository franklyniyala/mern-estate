import express from 'express';
import mongoose from 'mongoose';
import dotenv from 'dotenv';
import userRouter from './routes/user.route.js';
import authRouter from './routes/auth.route.js';
import listingRouter from './routes/listing.route.js';
import cookieParser from 'cookie-parser';
import path from 'path';

dotenv.config();

const buildMongoUri = () => {
  if (process.env.MONGO) return process.env.MONGO;

  const {
    MONGO_ROOT_USERNAME,
    MONGO_ROOT_PASSWORD,
    MONGO_DB_NAME,
    MONGO_HOST = '127.0.0.1',
    MONGO_PORT = '27017',
  } = process.env;

  if (MONGO_ROOT_USERNAME && MONGO_ROOT_PASSWORD && MONGO_DB_NAME) {
    return `mongodb://${encodeURIComponent(MONGO_ROOT_USERNAME)}:${encodeURIComponent(
      MONGO_ROOT_PASSWORD,
    )}@${MONGO_HOST}:${MONGO_PORT}/${MONGO_DB_NAME}?authSource=admin`;
  }

  return undefined;
};

const mongoUri = buildMongoUri();
if (!mongoUri) {
  console.error(
    'Missing MongoDB connection info. Set MONGO or MONGO_ROOT_USERNAME, MONGO_ROOT_PASSWORD, and MONGO_DB_NAME in .env.',
  );
  process.exit(1);
}

try {
  await mongoose.connect(mongoUri);
  console.log('Connected to MongoDB!');
} catch (err) {
  console.error('MongoDB connection failed:', err);
  process.exit(1);
}

const __dirname = path.resolve();
const app = express();

app.use(express.json());
app.use(cookieParser());

// ✅ API routes registered BEFORE app.listen()
app.use('/api/user', userRouter);
app.use('/api/auth', authRouter);
app.use('/api/listing', listingRouter);

// ✅ Serve frontend in production, fallback for ALL routes (not just '/')
if (process.env.NODE_ENV === 'production') {
  app.use(express.static(path.join(__dirname, '/client/dist')));

  app.get('*', (req, res) => {
    res.sendFile(path.join(__dirname, 'client', 'dist', 'index.html'));
  });
} else {
  // ✅ Development root route so browser doesn't show "Cannot GET /"
  app.get('/', (req, res) => {
    res.json({ status: 'Server is running!', env: process.env.NODE_ENV });
  });
}

// Error handler
app.use((err, req, res, next) => {
  const statusCode = err.statusCode || 500;
  const message = err.message || 'Internal Server Error';
  return res.status(statusCode).json({
    success: false,
    statusCode,
    message,
  });
});

// ✅ app.listen() comes LAST
app.listen(5000, () => {
  console.log('Server is running on port 5000!');
});
