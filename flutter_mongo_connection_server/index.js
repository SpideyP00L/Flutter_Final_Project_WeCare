const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');

const SERVER_NAME = 'Flutter_Final_Project';
const PORT = 9002;
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

const doctorSchema = new mongoose.Schema({
    Doctor_Full_Name: String,
    Doctor_Email: String,
    Doctor_Password: String,
  });
  
  const Doctor = mongoose.model('DoctorNewLogin', doctorSchema);

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

app.post('/api/doctor/register', async (req, res) => {
    try {
      console.log('Received data:', req.body);
  
      const { Doctor_Full_Name, Doctor_Email, Doctor_Password } = req.body;
  
      const doctor = new Doctor({ Doctor_Full_Name, Doctor_Email, Doctor_Password });
      await doctor.save();
  
      console.log('Doctor data saved:', doctor);
  
      res.status(201).json({ message: 'Doctor registered successfully' });
    } catch (error) {
      console.error('Error registering doctor:', error);
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

app.get('/api/nurse/name', async (req, res) => {
  try {
    const { email } = req.query;
    const nurse = await Nurse.findOne({ Nurse_Email: email });

    if (!nurse) {
      return res.status(404).json({ error: 'Nurse not found' });
    }

    res.status(200).json({ Nurse_Full_Name: nurse.Nurse_Full_Name });
  } catch (error) {
    console.error('Error fetching nurse name:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.post('/api/doctor/login', async (req, res) => {
    try {
      const { Doctor_Email, Doctor_Password } = req.body;
      const doctor = await Doctor.findOne({ Doctor_Email });
  
      if (!doctor) {
        return res.status(401).json({ error: 'Invalid email or password' });
      }
  
      // Compare the entered password with the stored password directly
      if (Doctor_Password !== doctor.Doctor_Password) {
        return res.status(401).json({ error: 'Invalid email or password' });
      }
  
      res.status(200).json({ message: 'Login successful' });
    } catch (error) {
      console.error('Error during doctor login:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  });

app.listen(PORT, HOST, () => {
  console.log(`${SERVER_NAME} server running at http://${HOST}:${PORT}`);
});
