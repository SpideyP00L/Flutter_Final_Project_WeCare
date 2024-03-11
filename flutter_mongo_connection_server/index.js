const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');

const SERVER_NAME = 'Flutter_Final_Project';
const PORT = 9001;
const HOST = '127.0.0.1';

const app = express();
app.use(express.json());
app.use(cors());

const uristring = 'mongodb+srv://admin:admin@flutter-final-project-c.dvwkiwm.mongodb.net/';

const nurseSchema = new mongoose.Schema({
  Nurse_Full_Name: String,
  Nurse_Email: String,
  Nurse_Password: String,
});

const Nurse = mongoose.model('NurseNewLogin', nurseSchema);

mongoose.connect(uristring, { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => console.log(`Connected to database: ${uristring}`))
  .catch(err => console.error('Connection error:', err));

app.post('/api/nurse/register', async (req, res) => {
  try {
    console.log('Received data:', req.body);

    const { Nurse_Full_Name, Nurse_Email, Nurse_Password } = req.body;

    const nurse = new Nurse({ Nurse_Full_Name, Nurse_Email, Nurse_Password });
    await nurse.save();

    console.log('Nurse data saved:', nurse);

    res.status(201).json({ message: 'Nurse registered successfully' });
  } catch (error) {
    console.error('Error registering nurse:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.post('/api/nurse/login', async (req, res) => {
  try {
    const { Nurse_Email, Nurse_Password } = req.body;
    const nurse = await Nurse.findOne({ Nurse_Email });

    if (!nurse) {
      return res.status(401).json({ error: 'Invalid email or password' });
    }

    // Compare the entered password with the stored password directly
    if (Nurse_Password !== nurse.Nurse_Password) {
      return res.status(401).json({ error: 'Invalid email or password' });
    }

    res.status(200).json({ message: 'Login successful' });
  } catch (error) {
    console.error('Error during nurse login:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.listen(PORT, HOST, () => {
  console.log(`${SERVER_NAME} server running at http://${HOST}:${PORT}`);
});
