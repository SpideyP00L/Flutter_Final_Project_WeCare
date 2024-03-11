const express = require('express');
const mongoose = require('mongoose');

const SERVER_NAME = 'Flutter_Final_Project';
const PORT = 9000;
const HOST = '127.0.0.1';

const app = express();
app.use(express.json());

const uristring = 'mongodb+srv://admin:admin@flutter-final-project-c.dvwkiwm.mongodb.net/';

const nurseSchema = new mongoose.Schema({
  fullName: String,
  email: String,
  password: String,
});

const Nurse = mongoose.model('NurseNewLogin', nurseSchema);

mongoose.connect(uristring, { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => console.log(`Connected to database: ${uristring}`))
  .catch(err => console.error('Connection error:', err));

app.post('/api/nurse/register', async (req, res) => {
  try {
    const { fullName, email, password } = req.body;

    // Basic validation
    if (!fullName || !email || !password) {
      return res.status(400).json({ error: 'Please provide all required fields' });
    }

    // Additional validation (you can customize this based on your requirements)
    if (password.length < 6) {
      return res.status(400).json({ error: 'Password must be at least 6 characters long' });
    }

    // Check if the email is already registered (assuming unique emails)
    const existingNurse = await Nurse.findOne({ email });
    if (existingNurse) {
      return res.status(400).json({ error: 'Email is already registered. Please use a different email.' });
    }

    const nurse = new Nurse({ fullName, email, password });
    await nurse.save();

    // Add console log message with saved data
    console.log('Nurse data saved:', nurse);

    res.status(201).json({ message: 'Nurse registered successfully' });
  } catch (error) {
    console.error('Error registering nurse:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.listen(PORT, HOST, () => {
  console.log(`${SERVER_NAME} server running at http://${HOST}:${PORT}`);
});
